//
//  CaseHelpsViewModel.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 16/10/26.
//
import Combine
import Foundation

@MainActor
final class CaseHelpsViewModel: ObservableObject {
  @Published var helpTypes: [HelpType] = []
  @Published var selectedIds: Set<String> = []
  @Published var isEditing = false
  @Published var isLoading = false
  @Published var isSaving = false
  @Published var errorMessage: String?
  @Published var showToast = false
  @Published var toastMessage = ""

  // helps saved in the backend, used to know if something changed
  private var savedIds: Set<String> = []

  private let caseId: String
  private let listHelpTypesUseCase: ListHelpTypesUseCaseProtocol
  private let assignCaseHelpsUseCase: AssignCaseHelpsUseCaseProtocol

  init(
    caseId: String,
    listHelpTypesUseCase: ListHelpTypesUseCaseProtocol = ListHelpTypesUseCase(),
    assignCaseHelpsUseCase: AssignCaseHelpsUseCaseProtocol = AssignCaseHelpsUseCase()
  ) {
    self.caseId = caseId
    self.listHelpTypesUseCase = listHelpTypesUseCase
    self.assignCaseHelpsUseCase = assignCaseHelpsUseCase
  }

  // the save button only turns on when there are changes
  var hasChanges: Bool { selectedIds != savedIds }

  // loads the catalog and marks the helps the case already has
  func load(assignedIds: [String]) async {
    isLoading = true
    errorMessage = nil
    savedIds = Set(assignedIds.map { $0.lowercased() })
    selectedIds = savedIds

    do {
      helpTypes = try await listHelpTypesUseCase.execute()
    } catch {
      errorMessage = "No se pudieron cargar los tipos de ayuda."
    }
    isLoading = false
  }

  func isSelected(id: String) -> Bool {
    selectedIds.contains(id.lowercased())
  }

  func toggle(id: String) {
    guard isEditing else { return }
    let id = id.lowercased()
    if selectedIds.contains(id) {
      selectedIds.remove(id)
    } else {
      selectedIds.insert(id)
    }
  }

  func startEditing() {
    isEditing = true
  }

  // cancel goes back to what is saved
  func cancelEditing() {
    selectedIds = savedIds
    isEditing = false
  }

  func save() async {
    guard hasChanges, !isSaving else { return }
    isSaving = true

    do {
      let result = try await assignCaseHelpsUseCase.execute(
        caseId: caseId,
        helpIds: Array(selectedIds)
      )
      // what the backend saved becomes the new starting point
      savedIds = Set(result.helps.map { $0.helpId.lowercased() })
      selectedIds = savedIds
      isEditing = false
      toastMessage = "Los tipos de ayuda se guardaron correctamente."
    } catch {
      toastMessage = "No se pudieron guardar los tipos de ayuda."
    }

    showToast = true
    isSaving = false
  }
}
