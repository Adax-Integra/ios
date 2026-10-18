//
//  ExternalProfileViewModel.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 05/10/26.
//

import Combine
import Foundation

// G-07: Shows the data of an external user and lets the admin edit the text fields
// The detail and the edit page share this ViewModel
@MainActor
final class ExternalProfileViewModel: ObservableObject {
  static let maxReasonLength = 500

  // Detail
  @Published private(set) var profile: ExternalUserProfile?
  // Values that came from the backend. Compared with the form to know what changed
  @Published private(set) var saved = ExternalProfileFormModel()
  @Published private(set) var countries: [Country] = []

  // Edit form
  @Published var form = ExternalProfileFormModel()
  @Published var reason = ""
  @Published var hasConsent = false
  // Turned on by the "Guardar" tap, so empty fields are not marked
  // as errors before the admin tries to save, same as the new case form
  @Published var showErrors = false

  // UI state
  @Published var isLoading = false
  @Published var isSaving = false
  @Published var isEditing = false
  @Published var isShowingConfirmation = false
  @Published var isShowingSuccessToast = false
  @Published var errorMessage: String?

  // Email that the backend answered as already registered (409)
  private var takenEmail: String?

  private let getExternalProfileUseCase: GetExternalProfileUseCaseProtocol
  private let updateExternalProfileUseCase: UpdateExternalProfileUseCaseProtocol
  private let countryRepository: CountryRepository
  private let userId: String

  // The API sends the birth date as "yyyy-MM-dd"
  private static let apiDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()

  private static let displayDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "es_MX")
    formatter.dateFormat = "dd/MM/yyyy"
    return formatter
  }()

  init(
    userId: String,
    getExternalProfileUseCase: GetExternalProfileUseCaseProtocol? = nil,
    updateExternalProfileUseCase: UpdateExternalProfileUseCaseProtocol? = nil,
    countryRepository: CountryRepository? = nil
  ) {
    self.userId = userId
    // Built here instead of as default arguments so they run on the main actor
    let repository = RemoteExternalProfileRepository()
    self.getExternalProfileUseCase =
      getExternalProfileUseCase ?? GetExternalProfileUseCase(dataRepository: repository)
    self.updateExternalProfileUseCase =
      updateExternalProfileUseCase ?? UpdateExternalProfileUseCase(dataRepository: repository)
    self.countryRepository =
      countryRepository ?? CachedCountryRepository(remote: RemoteCountryRepository())
  }

  // Values for the views

  var displayName: String {
    let name = profile?.profile?.name ?? ""
    let lastName = profile?.profile?.lastName ?? ""
    let fullName = "\(name) \(lastName)".trimmingCharacters(in: .whitespaces)
    return fullName.isEmpty ? "Sin nombre" : fullName
  }

  var initials: String {
    let first = profile?.profile?.name?.first.map(String.init) ?? ""
    let second = profile?.profile?.lastName?.first.map(String.init) ?? ""
    return (first + second).uppercased()
  }

  var birthDateText: String {
    guard let value = profile?.profile?.birthDate,
      let date = Self.apiDateFormatter.date(from: String(value.prefix(10)))
    else { return "Sin dato" }
    return Self.displayDateFormatter.string(from: date)
  }

  var countryOptions: [String] {
    countries.map(\.nameEs)
  }

  var stateOptions: [String] {
    Country.first(name: form.country ?? "", in: countries)?.stateNames ?? []
  }

  var changes: [ExternalProfileChange] {
    let fields: [(label: String, old: String, new: String)] = [
      ("Correo electrónico", cleanEmail(saved.email), cleanEmail(form.email)),
      ("Teléfono celular", phoneText(for: saved), phoneText(for: form)),
      ("País", saved.country ?? "", form.country ?? ""),
      ("Estado", saved.state ?? "", form.state ?? ""),
      ("Municipio/Localidad", clean(saved.municipality), clean(form.municipality)),
    ]

    return
      fields
      .filter { $0.old != $0.new }
      .map {
        ExternalProfileChange(
          label: $0.label, oldValue: display($0.old), newValue: display($0.new)
        )
      }
  }

  // Error messages for each field. They are computed,
  // so they disappear as soon as the admin fixes the field
  var emailError: String? { showErrors ? emailProblem : nil }
  var phoneError: String? { showErrors ? phoneProblem : nil }
  var stateError: String? { showErrors ? stateProblem : nil }
  var municipalityError: String? { showErrors ? municipalityProblem : nil }
  var reasonError: String? {
    showErrors && clean(reason).isEmpty ? "Este campo es obligatorio" : nil
  }
  var consentError: String? {
    showErrors && !hasConsent ? "Confirma que la externa autorizó el cambio" : nil
  }

  // Only the reason and the consent are required,
  // the other fields are checked only when the admin changed them
  var isFormValid: Bool {
    emailProblem == nil
      && phoneProblem == nil
      && stateProblem == nil
      && municipalityProblem == nil
      && !clean(reason).isEmpty
      && hasConsent
  }

  var trimmedReason: String {
    clean(reason)
  }

  // Both inboxes receive the notice when the email changes
  var noticeText: String {
    let newEmail = cleanEmail(form.email)
    if newEmail != cleanEmail(saved.email) {
      return "Se enviará un aviso a \(saved.email) y a \(newEmail) sin mostrar los datos nuevos."
    }
    return "Se enviará un aviso a \(saved.email) sin mostrar los datos nuevos."
  }

  func display(_ value: String?) -> String {
    let text = clean(value ?? "")
    return text.isEmpty ? "Sin dato" : text
  }

  func phoneText(for data: ExternalProfileFormModel) -> String {
    let digits = data.phone
    guard !digits.isEmpty else { return "" }
    let code = data.countryCode ?? ""
    guard digits.count == 10 else { return "\(code) \(digits)" }
    return "\(code) \(digits.prefix(3)) \(digits.dropFirst(3).prefix(3)) \(digits.suffix(4))"
  }

  // Actions
  func load() async {
    // Coming back from the edit page should not reload, apply() already has the new data
    guard profile == nil else { return }
    isLoading = true
    errorMessage = nil

    // The catalog is only needed to edit, so a failure here does not block the detail
    countries = (try? await countryRepository.getCountries()) ?? []

    do {
      let profile = try await getExternalProfileUseCase.getExternalProfile(for: userId)
      apply(profile)
    } catch {
      errorMessage = "No se pudo cargar la información de la externa."
    }

    isLoading = false
  }

  func startEditing() {
    form = saved
    reason = ""
    hasConsent = false
    showErrors = false
    takenEmail = nil
    isEditing = true
  }

  func cancelEditing() {
    isEditing = false
  }

  // A new country invalidates the selected state and the municipality
  func selectCountry(_ country: String?) {
    guard country != form.country else { return }
    form.country = country
    form.state = nil
    form.municipality = ""
  }

  // A new state invalidates the municipality
  func selectState(_ state: String?) {
    guard state != form.state else { return }
    form.state = state
    form.municipality = ""
  }

  // Without changes there is nothing to save, so it leaves like the back button.
  // Otherwise the first tap reveals the invalid fields
  func onSaveTapped() {
    guard !changes.isEmpty else {
      cancelEditing()
      return
    }
    showErrors = true
    guard isFormValid else { return }
    isShowingConfirmation = true
  }

  func confirm() async {
    isShowingConfirmation = false
    isSaving = true
    errorMessage = nil

    do {
      let updated = try await updateExternalProfileUseCase.updateExternalProfile(
        for: userId,
        with: makeRequest()
      )
      apply(updated)
      isEditing = false
      isShowingSuccessToast = true
    } catch {
      handle(error)
    }

    isSaving = false
  }

  // Private
  private func apply(_ profile: ExternalUserProfile) {
    self.profile = profile

    var data = ExternalProfileFormModel()
    data.email = profile.profile?.email ?? ""

    // The API sends one string like "+524421234567": the last 10 digits are the number
    let fullPhone = profile.profile?.phone ?? ""
    if fullPhone.count > 10 {
      data.countryCode = String(fullPhone.dropLast(10))
      data.phone = String(fullPhone.suffix(10))
    } else {
      data.phone = fullPhone
    }

    let address = profile.address
    data.country = address?.country
    data.state = address?.state
    data.municipality = address?.municipality ?? ""

    saved = data
    form = data
  }

  // Only the fields that changed go in the body
  private func makeRequest() -> UpdateExternalProfileRequest {
    let email = cleanEmail(form.email)
    let phone = fullPhone(form)

    let profileChanges = UpdateExternalProfileRequest.ProfileChanges(
      email: email != cleanEmail(saved.email) ? email : nil,
      phone: phone != fullPhone(saved) ? phone : nil
    )

    let addressChanges = UpdateExternalProfileRequest.AddressChanges(
      country: form.country != saved.country ? form.country : nil,
      state: form.state != saved.state ? form.state : nil,
      municipality: changed(form.municipality, saved.municipality)
    )

    return UpdateExternalProfileRequest(
      profile: profileChanges.isEmpty ? nil : profileChanges,
      address: addressChanges.isEmpty ? nil : addressChanges,
      reason: clean(reason),
      consentConfirmed: hasConsent
    )
  }

  // The address counts as changed when any of its three files changed
  private var addressChanged: Bool {
    form.country != saved.country
      || form.state != saved.state
      || clean(form.municipality) != clean(saved.municipality)
  }

  // Only checked when the admin chanhed the email
  private var emailProblem: String? {
    let email = cleanEmail(form.email)
    guard email != cleanEmail(saved.email) else { return nil }
    if email.range(of: #"^[^\s@]+@[^\s@]+\.[^\s@]+$"#, options: .regularExpression) == nil {
      return "Ingresa un correo electrónico válido"
    }
    if email == takenEmail {
      return "Este correo ya está registrado en otra cuenta."
    }
    return nil
  }

  // Only checked when teh admin changed the phone
  private var phoneProblem: String? {
    guard fullPhone(form) != fullPhone(saved) else { return nil }
    if form.phone.isEmpty {
      return "Ingresa un número válido"
    }
    return PhoneField.validationError(for: form.phone)
  }

  //The state depends on the country and the municipality on the state
  private var stateProblem: String? {
    guard addressChanged else { return nil }
    return form.country != nil && form.state == nil ? "Selecciona un estado" : nil
  }

  private var municipalityProblem: String? {
    guard addressChanged else { return nil }
    return form.state != nil && clean(form.municipality).isEmpty
      ? "Escribe el municipio o localidad" : nil
  }

  private func handle(_ error: Error) {
    guard case APIError.server(let statusCode, _) = error else {
      errorMessage = "No pudimos guardar los cambios. Revisa tu conexión e intenta de nuevo."
      return
    }

    switch statusCode {
    case 409:
      // The email field gets the red outline with the message
      takenEmail = cleanEmail(form.email)
      showErrors = true
    case 403: errorMessage = "No tienes permiso para modificar estos datos."
    case 404: errorMessage = "La cuenta de la externa no está disponible."
    case 400: errorMessage = "Revisa los datos e intenta de nuevo."
    default: errorMessage = "No pudimos guardar los cambios. Intenta de nuevo más tarde."
    }
  }

  // Returns the new value only when it is different from the saved one
  private func changed(_ value: String, _ savedValue: String) -> String? {
    let text = clean(value)
    return text != clean(savedValue) ? text : nil
  }

  private func fullPhone(_ data: ExternalProfileFormModel) -> String {
    data.phone.isEmpty ? "" : (data.countryCode ?? "") + data.phone
  }

  private func cleanEmail(_ value: String) -> String {
    clean(value).lowercased()
  }

  private func clean(_ value: String) -> String {
    value.trimmingCharacters(in: .whitespacesAndNewlines)
  }
}
