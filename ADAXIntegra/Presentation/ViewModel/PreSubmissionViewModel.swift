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

  private let repository: PreSubmissionRepository
  private let countryRepository: CountryRepository
  private let userId: String

  // Last loaded value from the body
  private var current: PreSubmission?

  private let onFinish: () -> Void

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

  func confirm(hasChanges: Bool) {
    guard hasChanges else {
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
          with: makePreSubmission(base: current)
        )
        apply(updated)
        isLoading = false
        onFinish()
      } catch {
        errorMessage = "No se pudo guardar tu información."
        isLoading = false
      }
    }
  }

  // Maps the entity to the form fields
  private func apply(_ preSubmission: PreSubmission) {
    current = preSubmission

    firstName = preSubmission.profile.name
    lastName = preSubmission.profile.lastName
    birthDate = Self.birthDateFormatter.date(from: preSubmission.profile.birthDate)
    phone = preSubmission.profile.phone

    addressLine1 = preSubmission.address.addressLine1
    addressLine2 = preSubmission.address.addressLine2
    neighborhood = preSubmission.address.neighborhood
    zipCode = preSubmission.address.zipCode
    country = preSubmission.address.country
    state = preSubmission.address.state
    municipality = preSubmission.address.city

    identityDocumentUrl = preSubmission.documents.identityDocumentUrl
    proofOfAddressUrl = preSubmission.documents.proofOfAddressUrl
  }

  // Builds the entity to send to the backend from the current form fields
  private func makePreSubmission(base: PreSubmission) -> PreSubmission {
    PreSubmission(
      id: base.id,
      profile: Profile(
        name: firstName,
        lastName: lastName,
        birthDate: birthDate.map(Self.birthDateFormatter.string(from:)) ?? base.profile.birthDate,
        phone: phone
      ),
      address: Address(
        addressLine1: addressLine1,
        addressLine2: addressLine2,
        neighborhood: neighborhood,
        zipCode: zipCode,
        country: country ?? base.address.country,
        state: state ?? base.address.state,
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
    phoneError = isBlank(phone) ? required : nil
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
