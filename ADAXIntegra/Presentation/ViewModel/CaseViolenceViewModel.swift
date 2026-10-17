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
  @Published var isLoading = false
  @Published var isSaving = false
  @Published var errorMessage: String?
  @Published var showToast = false
  @Published var toastMessage = ""

  // violence types saved in the backend that are used to know if something changed
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

  // urgency of the case with the current selection this changes while the internal marks the options
  var urgency: String {
    let severity =
      violenceTypes
      .filter { isSelected($0) }
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

  func isSelected(_ violence: ViolenceType) -> Bool {
    selectedIds.contains(violence.violenceId.lowercased())
  }

  func toggle(_ violence: ViolenceType) {
    let id = violence.violenceId.lowercased()
    if selectedIds.contains(id) {
      selectedIds.remove(id)
    } else {
      selectedIds.insert(id)
    }
  }

  // the success toast is skipped when the helps are saved right after so only one toast shows
  func save(showSuccessToast: Bool = true) async {
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

      if showSuccessToast {
        toastMessage = "Los tipos de violencia se guardaron correctamente."
        showToast = true
      }
    } catch {
      toastMessage = "No se pudieron guardar los tipos de violencia."
      showToast = true
    }

    isSaving = false
  }
}
