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
  @Published var isShowingStatusSuccess = false
  @Published var isShowingStatusToast = false
  @Published private(set) var statusToastMessage = ""
  @Published private(set) var shouldGoToLogin = false

  private let getCollaboratorDetailUseCase: GetCollaboratorDetailUseCaseProtocol
  private let getAssignedCasesUseCase: GetCollaboratorAssignedCasesUseCaseProtocol
  // G-04: use case to turn the account on or off
  private let updateStatusUseCase: UpdateCollaboratorStatusUseCaseProtocol
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
    updateStatusUseCase: UpdateCollaboratorStatusUseCaseProtocol? = nil
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

      // Success page, the errors keep using the toast
      isShowingStatusSuccess = true
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
