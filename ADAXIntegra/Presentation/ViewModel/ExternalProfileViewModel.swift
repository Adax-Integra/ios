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
  @Published var errors = ExternalProfileFormErrors()

  // UI state
  @Published var isLoading = false
  @Published var isSaving = false
  @Published var isEditing = false
  @Published var isShowingConfirmation = false
  @Published var isShowingSuccessToast = false
  @Published var errorMessage: String?

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
      ("Calle y número", clean(saved.addressLine1), clean(form.addressLine1)),
      ("Interior / dpto.", clean(saved.addressLine2), clean(form.addressLine2)),
      ("Colonia", clean(saved.neighborhood), clean(form.neighborhood)),
      ("Código postal", clean(saved.zipCode), clean(form.zipCode)),
      ("País", saved.country ?? "", form.country ?? ""),
      ("Estado", saved.state ?? "", form.state ?? ""),
      ("Ciudad / Municipio", clean(saved.city), clean(form.city)),
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

  // "Guardar" is enabled only with a change, a reason and the consent checked
  var canSave: Bool {
    !changes.isEmpty && !clean(reason).isEmpty && hasConsent && !isSaving
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
    errors = ExternalProfileFormErrors()
    isEditing = true
  }

  func cancelEditing() {
    isEditing = false
  }

  // A new country invalidates the selected state
  func selectCountry(_ country: String?) {
    guard country != form.country else { return }
    form.country = country
    form.state = nil
  }

  func onSaveTapped() {
    guard canSave, validate() else { return }
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
    data.addressLine1 = address?.addressLine1 ?? ""
    data.addressLine2 = address?.addressLine2 ?? ""
    data.neighborhood = address?.neighborhood ?? ""
    data.zipCode = address?.zipCode ?? ""
    data.country = address?.country
    data.state = address?.state
    data.city = address?.city ?? ""

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
      addressLine1: changed(form.addressLine1, saved.addressLine1),
      addressLine2: changed(form.addressLine2, saved.addressLine2),
      neighborhood: changed(form.neighborhood, saved.neighborhood),
      zipCode: changed(form.zipCode, saved.zipCode),
      country: form.country != saved.country ? form.country : nil,
      state: form.state != saved.state ? form.state : nil,
      city: changed(form.city, saved.city)
    )

    return UpdateExternalProfileRequest(
      profile: profileChanges.isEmpty ? nil : profileChanges,
      address: addressChanges.isEmpty ? nil : addressChanges,
      reason: clean(reason),
      consentConfirmed: hasConsent
    )
  }

  // Same rules as the backend. Fields that did not change are not checked
  private func validate() -> Bool {
    let required = "Este campo es obligatorio."
    var newErrors = ExternalProfileFormErrors()

    let email = cleanEmail(form.email)
    if email != cleanEmail(saved.email) {
      if email.isEmpty {
        newErrors.email = required
      } else if email.range(of: #"^[^\s@]+@[^\s@]+\.[^\s@]+$"#, options: .regularExpression) == nil
      {
        newErrors.email = "Por favor, introduce una dirección de correo electrónico válida."
      }
    }

    if fullPhone(form) != fullPhone(saved) {
      newErrors.phone = form.phone.isEmpty ? required : PhoneField.validationError(for: form.phone)
    }

    newErrors.addressLine1 = requiredError(form.addressLine1, saved.addressLine1)
    newErrors.neighborhood = requiredError(form.neighborhood, saved.neighborhood)
    newErrors.zipCode = requiredError(form.zipCode, saved.zipCode)
    newErrors.city = requiredError(form.city, saved.city)

    if form.state != saved.state && form.state == nil {
      newErrors.state = "Selecciona un estado."
    }

    if clean(reason).isEmpty {
      newErrors.reason = "El motivo es obligatorio."
    }

    errors = newErrors
    return newErrors.isEmpty
  }

  private func handle(_ error: Error) {
    guard case APIError.server(let statusCode, _) = error else {
      errorMessage = "No pudimos guardar los cambios. Revisa tu conexión e intenta de nuevo."
      return
    }

    switch statusCode {
    case 409: errors.email = "Este correo ya está registrado en otra cuenta."
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

  private func requiredError(_ value: String, _ savedValue: String) -> String? {
    let text = clean(value)
    guard text != clean(savedValue) else { return nil }
    return text.isEmpty ? "Este campo es obligatorio." : nil
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
