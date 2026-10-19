//
//  CaseViolenceViewModel.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 17/10/26.
//

import Combine
import Foundation

@MainActor
final class CaseViolenceViewModel: ObservableObject {
  @Published var violenceTypes: [ViolenceType] = []
  @Published var selectedIds: Set<String> = []
  @Published var isEditing = false
  @Published var isLoading = false
  @Published var isSaving = false
  @Published var errorMessage: String?
  @Published var showToast = false
  @Published var toastMessage = ""

  // violence types saved in the backend used to know if something changed
  private var savedIds: Set<String> = []

  private let caseId: String
  private let listViolenceTypesUseCase: ListViolenceTypesUseCaseProtocol
  private let assignViolenceTypesUseCase: AssignViolenceTypesUseCaseProtocol

  init(
    caseId: String,
    listViolenceTypesUseCase: ListViolenceTypesUseCaseProtocol = ListViolenceTypesUseCase(),
    assignViolenceTypesUseCase: AssignViolenceTypesUseCaseProtocol = AssignViolenceTypesUseCase()
  ) {
    self.caseId = caseId
    self.listViolenceTypesUseCase = listViolenceTypesUseCase
    self.assignViolenceTypesUseCase = assignViolenceTypesUseCase
  }

  var hasChanges: Bool { selectedIds != savedIds }

  // urgency of the case with the current selection

  var urgency: String {
    let severity =
      violenceTypes
      .filter { isSelected(id: $0.violenceId) }
      .compactMap(\.severity)
      .max()
    return CaseUrgency.from(severity: severity)
  }

  // loads the catalog and marks the violence types the case already has

  func load(assignedIds: [String]) async {
    isLoading = true
    errorMessage = nil
    savedIds = Set(assignedIds.map { $0.lowercased() })
    selectedIds = savedIds

    do {
      violenceTypes = try await listViolenceTypesUseCase.execute()
    } catch {
      errorMessage = "No se pudieron cargar los tipos de violencia."
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
      let result = try await assignViolenceTypesUseCase.execute(
        caseId: caseId,
        violenceIds: Array(selectedIds)
      )
      // what the backend saved becomes the new starting point
      savedIds = Set(result.violenceIds.map { $0.lowercased() })
      selectedIds = savedIds
      isEditing = false
      toastMessage = "Los tipos de violencia se guardaron correctamente."
    } catch {
      toastMessage = "No se pudieron guardar los tipos de violencia."
    }

    showToast = true
    isSaving = false
  }
}
