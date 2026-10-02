//
//  PreSubmissionViewModel.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 01/10/26.
//

import Combine
import Foundation

@MainActor
final class PreSubmissionViewModel: ObservableObject {

  @Published var firstName: String = ""
  @Published var lastName: String = ""
  @Published var birthDate: Date?
  @Published var countryCode: String? = "+52"
  @Published var phone: String = ""
  @Published var addressLine1: String = ""
  @Published var addressLine2: String = ""
  @Published var neighborhood: String = ""
  @Published var zipCode: String = ""
  @Published var country: String?
  @Published var state: String?
  @Published var municipality: String = ""

  /*
   Catalog for the country, state and phone code dropdowns.
   private(set)s are used so that only the view model can modify
   them.
   These are not "Set" type.
  */
  @Published private(set) var countries: [Country] = []

  @Published private(set) var identityDocumentUrl: String?
  @Published private(set) var proofOfAddressUrl: String?

  // Files the user picked. They stay nil until the user chooses a new one
  @Published private(set) var newIdentityDocument: DocumentFile?
  @Published private(set) var newProofOfAddress: DocumentFile?

  @Published var firstNameError: String?
  @Published var lastNameError: String?
  @Published var birthDateError: String?
  @Published var phoneError: String?
  @Published var addressLine1Error: String?
  @Published var neighborhoodError: String?
  @Published var zipCodeError: String?
  @Published var municipalityError: String?

  @Published var isLoading: Bool = false
  @Published var errorMessage: String?
  // True after a successful save, shows the confirmation message
  @Published var isShowingSuccess: Bool = false

  private let repository: PreSubmissionRepository
  private let countryRepository: CountryRepository
  private let userId: String

  // Last loaded value from the body
  private var current: PreSubmission?

  /*
   Copy of the fields taken every time apply() fills the form.
   Compared on confirm so an unchanged review doesn't send the put request.
   It is taken here, after the data arrives, and not when the view appears,
   because the fields are still empty at that moment.
  */
  private var original: captureInformation?

  // True once the user said the information is not correct, so "Terminar" always saves
  private var isEditing = false

  private let onFinish: () -> Void

  /*
   Create a copy of the reviewed fields.
   Equatable is a protocol used to compare two instances of a type,
   meaning you can use "==" and "!=" operators.
   Documents are display-only, so they are not part of the comparison.
  */
  private struct captureInformation: Equatable {
    var firstName: String
    var lastName: String
    var birthDate: Date?
    var countryCode: String?
    var phone: String
    var addressLine1: String
    var addressLine2: String
    var neighborhood: String
    var zipCode: String
    var country: String?
    var state: String?
    var municipality: String
  }

  // What the fields contain right now
  private var capture: captureInformation {
    captureInformation(
      firstName: firstName,
      lastName: lastName,
      birthDate: birthDate,
      countryCode: countryCode,
      phone: phone,
      addressLine1: addressLine1,
      addressLine2: addressLine2,
      neighborhood: neighborhood,
      zipCode: zipCode,
      country: country,
      state: state,
      municipality: municipality
    )
  }

  // False until the data is loaded, then true if the user changed a field or picked a file
  private var hasChanges: Bool {
    guard let original else { return false }
    return original != capture || newIdentityDocument != nil || newProofOfAddress != nil
  }

  /*
   The API sends and receives the birth date as "yyyy-MM-dd",
   while DateButton works with a Date.
   Instead of creating a function for formatting the date,
   it's better if we create a value and reuse evertime it
   is called.
  */
  private static let birthDateFormatter: DateFormatter = {
    // Creates an empty formatter
    let formatter = DateFormatter()
    // Make the format the same for every user or phone regardless of region
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()

  init(
    repository: PreSubmissionRepository,
    countryRepository: CountryRepository,
    userId: String,
    onFinish: @escaping () -> Void = {}
  ) {
    self.repository = repository
    self.countryRepository = countryRepository
    self.userId = userId
    self.onFinish = onFinish
  }

  // Loads the catalog and the preSubmission and fills the fields
  func load() async {
    isLoading = true
    errorMessage = nil

    do {
      /*
       The country catalog goes first so the dropdowns already have options
       when the saved country and state are selected.
      */
      countries = try await countryRepository.getCountries()
      let preSubmission = try await repository.getPreSubmission(for: userId)
      apply(preSubmission)
      isLoading = false
    } catch {
      errorMessage = "No se pudo cargar tu información."
      isLoading = false
    }
  }

  // Connected to the template's onDismiss, called when the user presses "No"
  func startEditing() {
    isEditing = true
  }

  /*
   Connected to the template's onConfirm.
   Skips the request when the user said the information is correct
   and did not change anything. After pressing "No" it always saves.
   */
  func confirm() {
    guard hasChanges || isEditing else {
      onFinish()
      return
    }
    guard validate(), let current else { return }

    isLoading = true
    errorMessage = nil

    Task {
      do {
        let updated = try await repository.editPreSubmission(
          for: userId,
          with: makePreSubmission(base: current),
          identityDocument: newIdentityDocument,
          proofOfAddress: newProofOfAddress
        )
        apply(updated)
        // The response already has the new signed URLs, so the picked files are done
        newIdentityDocument = nil
        newProofOfAddress = nil
        isLoading = false
        // onFinish runs when the user closes the message
        isShowingSuccess = true
      } catch {
        errorMessage = "No se pudo guardar tu información."
        isLoading = false
      }
    }
  }

  // Called when the user closes the success message
  func acknowledgeSuccess() {
    isShowingSuccess = false
    onFinish()
  }

  /*
   Signed URLs expire. When a document fails to load the view asks for new ones.
   Only the URLs are updated so the user's unsaved edits are not overwritten.
  */
  func refreshDocumentUrls() async {
    guard let fresh = try? await repository.getPreSubmission(for: userId) else { return }
    identityDocumentUrl = fresh.documents?.identityDocumentUrl
    proofOfAddressUrl = fresh.documents?.proofOfAddressUrl
  }

  // Called by the view when the user picks a file. Rejects files over 5 MB.
  func selectDocument(_ file: DocumentFile, for kind: DocumentKind) {
    guard !file.isTooLarge else {
      errorMessage = "El archivo no debe pesar más de 5 MB."
      return
    }
    errorMessage = nil

    switch kind {
    case .identity:
      newIdentityDocument = file
    case .proofOfAddress:
      newProofOfAddress = file
    }
  }

  // Maps the entity to the form fields
  private func apply(_ preSubmission: PreSubmission) {
    current = preSubmission

    // Profile, address and documents are null until the user fills them in for the first time
    let profile = preSubmission.profile
    let address = preSubmission.address

    firstName = profile?.name ?? ""
    lastName = profile?.lastName ?? ""
    birthDate = profile?.birthDate.flatMap(Self.birthDateFormatter.date(from:))
    /*
     The API sends one string like "+521234567890", due to the form having two fields.
     We need to add separate the country code from the phone number.
     */
    let fullPhone = profile?.phone ?? ""
    // Separate country code from phone number
    if fullPhone.count > 10 {
      countryCode = String(fullPhone.dropLast(10))
      phone = String(fullPhone.suffix(10))
    } else {
      phone = fullPhone
    }

    addressLine1 = address?.addressLine1 ?? ""
    addressLine2 = address?.addressLine2 ?? ""
    neighborhood = address?.neighborhood ?? ""
    zipCode = address?.zipCode ?? ""
    country = address?.country
    state = address?.state
    municipality = address?.city ?? ""

    identityDocumentUrl = preSubmission.documents?.identityDocumentUrl
    proofOfAddressUrl = preSubmission.documents?.proofOfAddressUrl

    original = capture
  }

  // Builds the entity to send to the backend from the current form fields
  private func makePreSubmission(base: PreSubmission) -> PreSubmission {
    PreSubmission(
      id: base.id,
      profile: Profile(
        name: firstName,
        lastName: lastName,
        birthDate: birthDate.map(Self.birthDateFormatter.string(from:)) ?? base.profile?.birthDate,
        phone: (countryCode ?? "") + phone
      ),
      address: Address(
        addressLine1: addressLine1,
        addressLine2: addressLine2,
        neighborhood: neighborhood,
        zipCode: zipCode,
        country: country ?? base.address?.country,
        state: state ?? base.address?.state,
        city: municipality
      ),
      documents: base.documents
    )
  }

  // Required fields. Address line 2 is optional
  private func validate() -> Bool {
    let required = "Este campo es obligatorio."

    firstNameError = isBlank(firstName) ? required : nil
    lastNameError = isBlank(lastName) ? required : nil
    birthDateError = birthDate == nil ? required : nil
    phoneError = isBlank(phone) ? required : PhoneField.validationError(for: phone)
    addressLine1Error = isBlank(addressLine1) ? required : nil
    neighborhoodError = isBlank(neighborhood) ? required : nil
    zipCodeError = isBlank(zipCode) ? required : nil
    municipalityError = isBlank(municipality) ? required : nil

    // Adds all the error message in one array and check that every one is null
    return [
      firstNameError, lastNameError, birthDateError, phoneError, addressLine1Error,
      neighborhoodError, zipCodeError, municipalityError,
    ].allSatisfy { $0 == nil }
  }

  // Validator to make sure users aren't sending blank data
  private func isBlank(_ text: String) -> Bool {
    text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }
}
