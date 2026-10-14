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

  @Published var form = PreSubmissionModel()

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

  @Published var errors = PreSubmissionErrors()

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
  private var original: PreSubmissionModel?

  // True once the user said the information is not correct, so "Terminar" always saves
  private var isEditing = false

  private let onFinish: () -> Void

  // False until the data is loaded, then true if the user changed a field or picked a file
  private var hasChanges: Bool {
    guard let original else { return false }
    return original != form || newIdentityDocument != nil || newProofOfAddress != nil
  }

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

    // Fill a copy so the view updates once
    var form = self.form

    form.firstName = profile?.name ?? ""
    form.lastName = profile?.lastName ?? ""

    form.birthDate = profile?.birthDate.flatMap(Date.parseBirthDate)
    /*
     The API sends one string like "+521234567890", due to the form having two fields.
     We need to add separate the country code from the phone number.
     */
    let fullPhone = profile?.phone ?? ""
    // Separate country code from phone number
    if fullPhone.count > 10 {
      form.countryCode = String(fullPhone.dropLast(10))
      form.phone = String(fullPhone.suffix(10))
    } else {
      form.phone = fullPhone
    }

    form.addressLine1 = address?.addressLine1 ?? ""
    form.addressLine2 = address?.addressLine2 ?? ""
    form.neighborhood = address?.neighborhood ?? ""
    form.zipCode = address?.zipCode ?? ""
    form.country = address?.country
    form.state = address?.state
    form.municipality = address?.city ?? ""

    self.form = form
    original = form

    identityDocumentUrl = preSubmission.documents?.identityDocumentUrl
    proofOfAddressUrl = preSubmission.documents?.proofOfAddressUrl
  }

  // Builds the entity to send to the backend from the current form fields
  private func makePreSubmission(base: PreSubmission) -> PreSubmission {
    PreSubmission(
      id: base.id,
      profile: Profile(
        name: form.firstName,
        lastName: form.lastName,
        birthDate: form.birthDate?.birthDateString ?? base.profile?.birthDate,
        phone: (form.countryCode ?? "") + form.phone
      ),
      address: Address(
        addressLine1: form.addressLine1,
        addressLine2: form.addressLine2,
        neighborhood: form.neighborhood,
        zipCode: form.zipCode,
        country: form.country ?? base.address?.country,
        state: form.state ?? base.address?.state,
        city: form.municipality
      ),
      documents: base.documents
    )
  }

  // Required fields. Address line 2 is optional
  private func validate() -> Bool {
    let required = "Este campo es obligatorio."

    errors = PreSubmissionErrors(
      firstName: isBlank(form.firstName) ? required : nil,
      lastName: isBlank(form.lastName) ? required : nil,
      birthDate: form.birthDate == nil ? required : nil,
      phone: isBlank(form.phone) ? required : PhoneField.validationError(for: form.phone),
      addressLine1: isBlank(form.addressLine1) ? required : nil,
      neighborhood: isBlank(form.neighborhood) ? required : nil,
      zipCode: isBlank(form.zipCode) ? required : nil,
      municipality: isBlank(form.municipality) ? required : nil
    )
    return errors.isEmpty
  }

  // Validator to make sure users aren't sending blank data
  private func isBlank(_ text: String) -> Bool {
    text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }
}
