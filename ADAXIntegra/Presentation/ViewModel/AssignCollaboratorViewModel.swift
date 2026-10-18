//
//  AssignCollaboratorViewModel.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 17/10/26.
//
//  ViewModel for US R-10, assign an internal user to a case
//

import Combine
import Foundation

@MainActor
final class AssignCollaboratorViewModel: ObservableObject {
  @Published private(set) var collaborators: [AssignableCollaborator] = []
  @Published var searchText = ""
  @Published private(set) var selectedIds: Set<String> = []
  @Published private(set) var isLoading = false
  @Published private(set) var isAssigning = false
  @Published private(set) var errorMessage: String?
  // Shown above the button when the backend rejects the assignment
  @Published private(set) var assignError: String?

  private let caseId: String
  // Collaborators already saved in the case, there is no endpoint to remove them so they stay selected
  private let assignedIds: Set<String>
  private let listAssignableCollaboratorsUseCase: ListAssignableCollaboratorsUseCaseProtocol
  private let assignCaseCollaboratorUseCase: AssignCaseCollaboratorUseCaseProtocol

  init(
    caseId: String,
    assignedIds: Set<String> = [],
    listAssignableCollaboratorsUseCase: ListAssignableCollaboratorsUseCaseProtocol? = nil,
    assignCaseCollaboratorUseCase: AssignCaseCollaboratorUseCaseProtocol? = nil
  ) {
    self.caseId = caseId
    self.assignedIds = assignedIds
    self.selectedIds = assignedIds
    self.listAssignableCollaboratorsUseCase =
      listAssignableCollaboratorsUseCase ?? ListAssignableCollaboratorsUseCase()
    self.assignCaseCollaboratorUseCase =
      assignCaseCollaboratorUseCase ?? AssignCaseCollaboratorUseCase()
  }

  // Search by name, an empty search shows everyone
  var filteredCollaborators: [AssignableCollaborator] {
    let query = searchText.trimmingCharacters(in: .whitespaces)
    guard !query.isEmpty else { return collaborators }
    return collaborators.filter { $0.fullName.localizedCaseInsensitiveContains(query) }
  }

  // Selected collaborators that are not saved yet, only these are sent so the activity log
  var newIds: Set<String> { selectedIds.subtracting(assignedIds) }

  var canAssign: Bool { !newIds.isEmpty && !isAssigning }

  // The backend already leaves out deactivated accounts and sorts by name
  func load() async {
    isLoading = true
    errorMessage = nil

    do {
      collaborators = try await listAssignableCollaboratorsUseCase.execute()
    } catch {
      handleLoadError(error)
    }
    isLoading = false
  }

  func isSelected(_ item: AssignableCollaborator) -> Bool {
    selectedIds.contains(item.id)
  }

  func isAssigned(_ item: AssignableCollaborator) -> Bool {
    assignedIds.contains(item.id)
  }

  // Several collaborators can be selected, tapping one again unselects her
  func toggle(_ item: AssignableCollaborator) {
    guard !isAssigned(item) else { return }
    if selectedIds.contains(item.id) {
      selectedIds.remove(item.id)
    } else {
      selectedIds.insert(item.id)
    }
  }

  // The new selected collaborators are sent in one call, returns true when the backend saved them
  func assign() async -> Bool {
    guard canAssign else { return false }
    isAssigning = true
    assignError = nil
    defer { isAssigning = false }

    do {
      // Kept in the list order so the request is always the same for the same selection
      return try await assignCaseCollaboratorUseCase.execute(
        caseId: caseId,
        userIds: collaborators.map(\.id).filter { newIds.contains($0) }
      )
    } catch {
      handle(error)
      return false
    }
  }

  private func handleLoadError(_ error: Error) {
    guard case let APIError.server(statusCode, _) = error else {
      errorMessage = "Revisa tu conexión e intenta de nuevo."
      return
    }

    switch statusCode {
    case 401:
      errorMessage = "Tu sesión expiró. Vuelve a iniciar sesión."
    case 403:
      errorMessage = "No tienes permiso para consultar las colaboradoras."
    default:
      errorMessage = "Revisa tu conexión e intenta de nuevo."
    }
  }

  // The backend messages come in English, so each code gets its spanish message
  private func handle(_ error: Error) {
    guard case let APIError.server(statusCode, data) = error else {
      assignError = "No se pudo conectar con el servidor. Intenta de nuevo."
      return
    }

    let body = data.flatMap { try? JSONDecoder().decode(APIErrorResponse.self, from: $0) }

    switch (statusCode, body?.code) {
    case (_, "CASE_CLOSED"):
      assignError = "El caso está cerrado, no se puede asignar."
    case (_, "COLLABORATOR_INACTIVE"):
      assignError = "Una de las colaboradoras seleccionadas está desactivada, no se asignó a nadie."
    case (_, "COLLABORATOR_NOT_FOUND"):
      assignError = "No se encontró a una de las colaboradoras seleccionadas, no se asignó a nadie."
    case (_, "CASE_NOT_FOUND"):
      assignError = "No se encontró el caso."
    case (401, _):
      assignError = "Tu sesión expiró. Vuelve a iniciar sesión."
    case (403, _):
      assignError = "No tienes permiso para asignar colaboradoras."
    default:
      assignError = "No se pudo asignar a las colaboradoras. Intenta de nuevo."
    }
  }
}
