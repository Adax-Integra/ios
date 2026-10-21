//
//  AssignCollaboratorViewModel.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 17/10/26.
//

import Combine
import Foundation

@MainActor
final class AssignCollaboratorViewModel: ObservableObject {
  @Published private(set) var collaborators: [AssignableCollaborator] = []
  @Published var searchText = ""
  @Published private(set) var selectedIds: Set<String> = []
  @Published private(set) var isLoading = false
  @Published private(set) var isSaving = false
  @Published private(set) var errorMessage: String?
  // Shown above the button when the backend rejects the changes
  @Published private(set) var saveError: String?

  private let caseId: String
  // Collaborators saved in the case
  private(set) var assignedIds: Set<String>
  private let listAssignableCollaboratorsUseCase: ListAssignableCollaboratorsUseCaseProtocol
  private let updateCaseCollaboratorsUseCase: UpdateCaseCollaboratorsUseCaseProtocol

  init(
    caseId: String,
    assignedIds: Set<String> = [],
    listAssignableCollaboratorsUseCase: ListAssignableCollaboratorsUseCaseProtocol? = nil,
    updateCaseCollaboratorsUseCase: UpdateCaseCollaboratorsUseCaseProtocol? = nil
  ) {
    self.caseId = caseId
    self.assignedIds = assignedIds
    self.selectedIds = assignedIds
    self.listAssignableCollaboratorsUseCase =
      listAssignableCollaboratorsUseCase ?? ListAssignableCollaboratorsUseCase()
    self.updateCaseCollaboratorsUseCase =
      updateCaseCollaboratorsUseCase ?? UpdateCaseCollaboratorsUseCase()
  }

  // Search by name, an empty search shows everyone
  var filteredCollaborators: [AssignableCollaborator] {
    let query = searchText.trimmingCharacters(in: .whitespaces)
    let matching =
      query.isEmpty
      ? collaborators
      : collaborators.filter { $0.fullName.localizedCaseInsensitiveContains(query) }
    // saved collaborators go first, each group keeps the order by name
    return matching.filter { isAssigned($0) } + matching.filter { !isAssigned($0) }
  }

  // Selected collaborators that are not saved yet
  var addedIds: Set<String> { selectedIds.subtracting(assignedIds) }

  // Saved collaborators that were unselected, the backend removes them from the case
  var removedIds: Set<String> { assignedIds.subtracting(selectedIds) }

  var changesCount: Int { addedIds.count + removedIds.count }

  var canSave: Bool { changesCount > 0 && !isSaving }

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

  // Several collaborators can be selected, tapping one again unselects her even if she is saved
  func toggle(_ item: AssignableCollaborator) {
    if selectedIds.contains(item.id) {
      selectedIds.remove(item.id)
    } else {
      selectedIds.insert(item.id)
    }
  }

  // Sends the final list in one call, returns true when the backend saved it
  func save() async -> Bool {
    guard canSave else { return false }
    isSaving = true
    saveError = nil
    defer { isSaving = false }

    do {
      let savedIds = try await updateCaseCollaboratorsUseCase.execute(
        caseId: caseId,
        userIds: finalIds
      )
      // What the backend saved becomes the new starting point
      assignedIds = Set(savedIds)
      selectedIds = assignedIds
      return true
    } catch {
      handle(error)
      return false
    }
  }

  // Kept in the list order so the request is always the same for the same selection.
  private var finalIds: [String] {
    let listed = collaborators.map(\.id).filter { selectedIds.contains($0) }
    let notListed = selectedIds.subtracting(listed).sorted()
    return listed + notListed
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

  private func handle(_ error: Error) {
    guard case let APIError.server(statusCode, data) = error else {
      saveError = "No se pudo conectar con el servidor. Intenta de nuevo."
      return
    }

    let body = data.flatMap { try? JSONDecoder().decode(APIErrorResponse.self, from: $0) }

    switch (statusCode, body?.code) {
    case (_, "CASE_CLOSED"):
      saveError = "El caso está cerrado, no se pueden cambiar las colaboradoras."
    case (_, "COLLABORATOR_INACTIVE"):
      saveError =
        "Una de las colaboradoras seleccionadas está desactivada, no se guardaron los cambios."
    case (_, "COLLABORATOR_NOT_FOUND"):
      saveError =
        "No se encontró a una de las colaboradoras seleccionadas, no se guardaron los cambios."
    case (_, "CASE_NOT_FOUND"):
      saveError = "No se encontró el caso."
    case (401, _):
      saveError = "Tu sesión expiró. Vuelve a iniciar sesión."
    case (403, _):
      saveError = "No tienes permiso para cambiar las colaboradoras del caso."
    default:
      saveError = "No se pudieron guardar los cambios. Intenta de nuevo."
    }
  }
}
