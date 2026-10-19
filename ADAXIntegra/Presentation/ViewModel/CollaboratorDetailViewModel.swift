//
//  CollaboratorDetailViewModel.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 17/10/26.
//

import Combine
import Foundation

// Tabs of the collaborator detail only "general" y "casos"
enum CollaboratorDetailTab: Hashable {
  case general
  case cases
}

// Loads the detail of a collaborator and the cases assigned to that user for US g-10
@MainActor
final class CollaboratorDetailViewModel: ObservableObject {
  // Detail
  @Published private(set) var detail: CollaboratorDetail?

  // Cases tab
  @Published private(set) var cases: [CollaboratorAssignedCase] = []
  @Published private(set) var hasLoadedCases = false

  // UI state
  @Published private(set) var isLoading = false
  @Published private(set) var isLoadingCases = false
  @Published private(set) var errorMessage: String?
  @Published private(set) var casesErrorMessage: String?
  @Published var selectedTab: CollaboratorDetailTab = .general
  @Published var searchText = ""
  // "Casos Activos" chip only open cases are shown
  @Published var onlyActiveCases = true
  @Published var isShowingCopiedToast = false

  // G-04: state for changing the account status
  @Published private(set) var isUpdatingStatus = false
  @Published var isShowingStatusToast = false
  @Published private(set) var statusToastMessage = ""
  @Published private(set) var shouldGoToLogin = false
 // G-11: state for editing the data of the collaborator in place
  @Published private(set) var isEditing = false
  @Published private(set) var isSavingEdit = false
  @Published var editName = ""
  @Published var editLastName = ""
  @Published var editEmail = ""
  @Published var editCountryCode: String? = "+52"
 // Only the 10 digits of the number, the country code travels apart
  @Published var editPhone = ""
  @Published var showEditErrors = false
  @Published var isShowingEditToast = false
  @Published private(set) var editToastMessage = ""
 // Email that the backend rejected with 409, so the field shows the error
  @Published private(set) var takenEmail: String?

  private let getCollaboratorDetailUseCase: GetCollaboratorDetailUseCaseProtocol
  private let getAssignedCasesUseCase: GetCollaboratorAssignedCasesUseCaseProtocol
  // G-04: use case to turn the account on or off
  private let updateStatusUseCase: UpdateCollaboratorStatusUseCaseProtocol
    // G-11: use case to save the edited data
  private let editUseCase: EditCollaboratorUseCaseProtocol
  private static let maxNameLength = 50
  private static let maxEmailLength = 128
  private let userId: String

  private static let apiDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()

  private static let monthYearFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "es_MX")
    formatter.dateFormat = "MMM yyyy"
    return formatter
  }()

  private static let fullDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "es_MX")
    formatter.dateFormat = "d MMM yyyy"
    return formatter
  }()

  init(
    userId: String,
    getCollaboratorDetailUseCase: GetCollaboratorDetailUseCaseProtocol? = nil,
    getAssignedCasesUseCase: GetCollaboratorAssignedCasesUseCaseProtocol? = nil,
    updateStatusUseCase: UpdateCollaboratorStatusUseCaseProtocol? = nil,
    editUseCase: EditCollaboratorUseCaseProtocol? = nil
      ) {
    self.userId = userId
    let repository = RemoteCollaboratorDetailRepository()
    self.getCollaboratorDetailUseCase =
      getCollaboratorDetailUseCase ?? GetCollaboratorDetailUseCase(dataRepository: repository)
    self.getAssignedCasesUseCase =
      getAssignedCasesUseCase ?? GetCollaboratorAssignedCasesUseCase(dataRepository: repository)
    // G-04: uses the same repository as the collaborator detail
    self.updateStatusUseCase =
      updateStatusUseCase ?? UpdateCollaboratorStatusUseCase(dataRepository: repository)
    // G-11: independent repository, it only needs the PATCH of the profile
    self.editUseCase =
      editUseCase ?? EditCollaboratorUseCase(dataRepository: RemoteEditCollaboratorRepository())
  }

  // Values for the views
  func updatedAtText(for item: CollaboratorAssignedCase) -> String {
    guard let date = date(from: item.updatedAt) else { return "Sin datos" }
    return Self.fullDateFormatter.string(from: date)
  }

  //  "Open" or "Closed"
  func stateText(for item: CollaboratorAssignedCase) -> String {
    switch item.state {
    case "Open": return "Abierto"
    case "Closed": return "Cerrado"
    default: return "Sin estado"
    }
  }

  // Violence types joined in one line, or a message when the case has none
  func violenceText(for item: CollaboratorAssignedCase) -> String {
    item.violenceTypes.isEmpty ? "Sin registrar" : item.violenceTypes.joined(separator: ", ")
  }

  // Only the "internal" role for all collaborators
  var roleText: String {
    guard let role = detail?.role else { return "Sin dato" }
    return role == "internal" ? "Interna / colaboradora" : role
  }

  // Since when they were created in the app shown in the header
  var memberSinceText: String {
    guard let date = date(from: detail?.joinedAt) else { return "Sin fecha de ingreso" }
    return "Desde \(Self.monthYearFormatter.string(from: date))"
  }

  var joinedAtText: String {
    guard let date = date(from: detail?.joinedAt) else { return "Sin dato" }
    return Self.fullDateFormatter.string(from: date)
  }

  var officeText: String {
    let office = detail?.office?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    return office.isEmpty ? "Sin sede asignada" : office
  }

  // Phone number is a string like "+524421782987" the last 10 digits are the number
  var phoneText: String {
    guard let phone = detail?.phone, !phone.isEmpty else { return "Sin teléfono" }
    guard phone.count > 10 else { return phone }
    let code = phone.dropLast(10)
    let digits = phone.suffix(10)
    return "\(code) \(digits.prefix(3)) \(digits.dropFirst(3).prefix(3)) \(digits.suffix(4))"
  }

  // Text of the "Estatus en la organización" card
  var statusDescription: String {
    if detail?.isActive == false {
      return
        "No puede iniciar sesión ni recibir nuevas asignaciones. Sus casos actuales permanecen en el expediente hasta que se reasignen."
    }
    return "Puede iniciar sesión y recibir nuevas asignaciones."
  }

  // Title of the "Casos" tab
  var casesTitle: String {
    "Casos asignados a \(detail?.name ?? "la colaboradora")"
  }

  // Applies the chip and the search item for the case number or name
  var filteredCases: [CollaboratorAssignedCase] {
    let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

    return cases.filter { item in
      if onlyActiveCases && item.state != "Open" { return false }
      guard !query.isEmpty else { return true }
      return matches(item.caseNumber, query) || matches(item.name, query)
    }
  }

  // Actions

  func load(force: Bool = false) async {
    // Si force es true, ignoramos si detail ya tiene datos
    guard force || detail == nil else { return }
    isLoading = true
    errorMessage = nil
    defer { isLoading = false }

    do {
      detail = try await getCollaboratorDetailUseCase.getCollaboratorDetail(for: userId)
    } catch {
      errorMessage = message(for: error, subject: "la información de la colaboradora")
    }
  }

  func loadCases(force: Bool = false) async {
    guard !isLoadingCases else { return }
    guard force || !hasLoadedCases else { return }

    isLoadingCases = true
    casesErrorMessage = nil
    defer { isLoadingCases = false }

    do {
      let result = try await getAssignedCasesUseCase.getAssignedCases(for: userId)
      cases = result.cases
      hasLoadedCases = true
    } catch {
      casesErrorMessage = message(for: error, subject: "los casos asignados")
    }
  }

  // The view writes in the portapepeles and the ViewModel only shows the confirmation
  func didCopy() {
    isShowingCopiedToast = true
  }

  // G-04: turns the account on or off, called when "Confirmar" is tapped
  func changeStatus() async {
    // Stop if the collaborator data has not loaded yet
    guard let detail else { return }

    // If the account is active we turn it off, and the other way around
    let newStatus = !detail.isActive

    isUpdatingStatus = true

    do {
      // Send the PATCH to the backend, it answers with the saved status
      let result = try await updateStatusUseCase.updateStatus(userId: userId, isActive: newStatus)

      // Update only the status on screen, no need to load the whole detail again
      self.detail?.isActive = result.isActive

      // Success message at the bottom of the screen
      if newStatus {
        statusToastMessage = "La cuenta se activó correctamente."
      } else {
        statusToastMessage = "La cuenta se desactivó correctamente."
      }
      isShowingStatusToast = true
    } catch {
      await handleStatusError(error)
    }

    isUpdatingStatus = false
  }

  // G-04: picks the error message to show, based on what the backend answered
  private func handleStatusError(_ error: Error) async {
    // The server did not answer (no internet or server down)
    guard case APIError.server(let statusCode, _) = error else {
      statusToastMessage = "No se pudo conectar con el servidor. Revisa tu conexión a internet."
      isShowingStatusToast = true
      return
    }

    switch statusCode {
    case 400:
      statusToastMessage = "No se pudo procesar el cambio. Intenta de nuevo."
    case 401:
      // The session expired, the page sends the user back to the login
      shouldGoToLogin = true
      return
    case 403:
      statusToastMessage = "No tienes permiso para cambiar el estatus de esta cuenta."
    case 404:
      statusToastMessage = "No encontramos la cuenta de esta colaboradora."
    case 409:
      statusToastMessage = "La cuenta ya tenía ese estatus."
      // Load again to show the real status
      await load(force: true)
    case 429:
      statusToastMessage = "Hiciste demasiados intentos. Espera un momento e intenta de nuevo."
    default:
      statusToastMessage = "Ocurrió un error en el servidor. Intenta más tarde."
    }

    isShowingStatusToast = true
  }

    // G-11: edit in place

    // Country codes of the dropdown, plus the saved one if it is not in the list
    var countryCodeOptions: [String] {
      var options = ["+52", "+1"]
      if let code = editCountryCode, !options.contains(code) {
        options.append(code)
      }
      return options
    }

    var editNameError: String? {
      guard showEditErrors, clean(editName) != savedName else { return nil }
      return nameProblem(clean(editName), field: "nombre")
    }

    var editLastNameError: String? {
      guard showEditErrors, clean(editLastName) != savedLastName else { return nil }
      return nameProblem(clean(editLastName), field: "apellidos")
    }

    var editEmailError: String? {
      guard showEditErrors else { return nil }
      return emailProblem
    }

    var editPhoneError: String? {
      guard showEditErrors else { return nil }
      return phoneProblem
    }

    // True when at least one field is different from what is saved
    var hasEditChanges: Bool {
      clean(editName) != savedName
        || clean(editLastName) != savedLastName
        || cleanEmail(editEmail) != savedEmail
        || newPhone != savedPhone
    }

    // Opens the edit mode with the saved values in the fields
    func startEditing() {
      guard detail != nil else { return }

      let phone = Self.splitPhone(detail?.phone)
      editName = savedName
      editLastName = savedLastName
      editEmail = savedEmail
      editCountryCode = phone.code
      editPhone = phone.number
      takenEmail = nil
      showEditErrors = false
      selectedTab = .general
      isEditing = true
    }

    // Closes the edit mode without saving, it cannot be done while saving
    func cancelEditing() {
      guard !isSavingEdit else { return }
      isEditing = false
      showEditErrors = false
    }

    // Saves the changes and reloads the detail so every card shows the new data
    func saveEdits() async {
      guard isEditing, !isSavingEdit else { return }

      // Nothing changed, just leave the edit mode
      guard hasEditChanges else {
        isEditing = false
        return
      }

      showEditErrors = true
      guard isEditFormValid else { return }

      isSavingEdit = true

      do {
        try await editUseCase.editCollaborator(userId: userId, request: makeEditRequest())

        // The G-10 detail is loaded again, so the header and the cards update right away
        await load(force: true)

        isEditing = false
        editToastMessage = "Los datos se actualizaron correctamente."
        isShowingEditToast = true
      } catch {
        handleEditError(error)
      }

      isSavingEdit = false
    }

    // Private (G-11)

    private var savedName: String { clean(detail?.name ?? "") }
    private var savedLastName: String { clean(detail?.lastName ?? "") }
    private var savedEmail: String { cleanEmail(detail?.email ?? "") }

    // Saved phone as "+52" + 10 digits, empty when the collaborator has no phone
    private var savedPhone: String {
      let phone = Self.splitPhone(detail?.phone)
      return phone.number.isEmpty ? "" : phone.code + phone.number
    }

    // Phone typed in the form as "+52" + 10 digits, empty when the field is empty
    private var newPhone: String {
      let digits = editPhone.filter(\.isNumber)
      guard !digits.isEmpty else { return "" }
      return (editCountryCode ?? "+52") + digits
    }

    private var isEditFormValid: Bool {
      (clean(editName) == savedName || nameProblem(clean(editName), field: "nombre") == nil)
        && (clean(editLastName) == savedLastName
          || nameProblem(clean(editLastName), field: "apellidos") == nil)
        && emailProblem == nil
        && phoneProblem == nil
        && hasEditChanges
    }

    private var emailProblem: String? {
      let value = cleanEmail(editEmail)
      guard value != savedEmail else { return nil }
      if value.range(of: #"^[^\s@]+@[^\s@]+\.[^\s@]+$"#, options: .regularExpression) == nil {
        return "Ingresa un correo electrónico válido"
      }
      if value.count > Self.maxEmailLength {
        return "Máximo \(Self.maxEmailLength) caracteres"
      }
      if value == takenEmail {
        return "Este correo ya está registrado en otra cuenta."
      }
      return nil
    }

    private var phoneProblem: String? {
      guard newPhone != savedPhone else { return nil }
      let digits = editPhone.filter(\.isNumber)
      // The backend cannot remove a phone, so it cannot be left empty once it exists
      if digits.isEmpty { return "El teléfono no puede quedar vacío" }
      return PhoneField.validationError(for: digits)
    }

    private func nameProblem(_ value: String, field: String) -> String? {
      if value.isEmpty { return "El campo \(field) es obligatorio" }
      if value.count > Self.maxNameLength {
        return "Máximo \(Self.maxNameLength) caracteres"
      }
      return nil
    }

    // Only the changed fields are sent, the backend rejects a body without changes
    private func makeEditRequest() -> EditCollaboratorRequest {
      let newName = clean(editName)
      let newLastName = clean(editLastName)
      let newEmail = cleanEmail(editEmail)

      return EditCollaboratorRequest(
        profile: EditCollaboratorRequest.Profile(
          name: newName != savedName ? newName : nil,
          lastName: newLastName != savedLastName ? newLastName : nil,
          email: newEmail != savedEmail ? newEmail : nil,
          phone: newPhone != savedPhone ? newPhone : nil
        )
      )
    }

    // G-11: picks the message to show, based on what the backend answered
    private func handleEditError(_ error: Error) {
      // The server did not answer
      guard case APIError.server(let statusCode, _) = error else {
        editToastMessage = "No fue posible guardar los cambios, intenta de nuevo."
        isShowingEditToast = true
        return
      }

      switch statusCode {
      case 409:
        // The field shows the error, no toast needed
        takenEmail = cleanEmail(editEmail)
        showEditErrors = true
        return
      case 401:
        // The session expired, the page sends the user back to the login
        shouldGoToLogin = true
        return
      case 400: editToastMessage = "Revisa los datos e intenta de nuevo."
      case 403: editToastMessage = "No tienes permiso para modificar estos datos."
      case 404: editToastMessage = "La cuenta de la colaboradora no está disponible."
      case 429: editToastMessage = "Hiciste demasiados intentos. Espera un momento e intenta de nuevo."
      default: editToastMessage = "No pudimos guardar los cambios. Intenta de nuevo más tarde."
      }

      isShowingEditToast = true
    }

    // Splits the number  into the country code and the 10 digits of the number
    private static func splitPhone(_ phone: String?) -> (code: String, number: String) {
      guard let phone, !phone.isEmpty else { return ("+52", "") }
      guard phone.count > 10 else { return ("+52", phone.filter(\.isNumber)) }
      return (String(phone.dropLast(10)), String(phone.suffix(10)))
    }

    private func cleanEmail(_ value: String) -> String {
      clean(value).lowercased()
    }

    private func clean(_ value: String) -> String {
      value.trimmingCharacters(in: .whitespacesAndNewlines)
    }

  // Private

  private func date(from value: String?) -> Date? {
    guard let value else { return nil }
    return Self.apiDateFormatter.date(from: String(value.prefix(10)))
  }

  private func matches(_ value: String?, _ query: String) -> Bool {
    guard let value else { return false }
    return value.range(of: query, options: [.caseInsensitive, .diacriticInsensitive]) != nil
  }

  private func message(for error: Error, subject: String) -> String {
    guard case APIError.server(let statusCode, _) = error else {
      return "No se pudo cargar \(subject). Intenta de nuevo."
    }

    switch statusCode {
    case 403: return "No tienes permiso para ver esta información."
    case 404: return "La cuenta de la colaboradora no está disponible."
    default: return "No se pudo cargar \(subject). Intenta de nuevo más tarde."
    }
  }
}
