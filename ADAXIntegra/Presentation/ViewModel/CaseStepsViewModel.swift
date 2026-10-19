//
//  CaseStepsViewModel.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 18/10/26.
//

import Combine
import Foundation

@MainActor
final class CaseStepViewModel: ObservableObject {
  @Published private(set) var selectedStep: CaseStepOption?
  @Published private var savedStep: CaseStepOption?
  @Published private(set) var isSaving = false
  @Published var showToast = false
  @Published var toastMessage = ""

  private let repository: CaseRepository
  private let caseId: String

  init(caseId: String, repository: CaseRepository = RemoteCaseRepository()) {
    self.caseId = caseId
    self.repository = repository
  }

  // Only changes if selected steps differs from previous step
  var hasChanges: Bool { selectedStep != nil && selectedStep != savedStep }

  func setInitial(stepNumber: Int?) {
    let step = stepNumber.flatMap { CaseStepOption(rawValue: $0) }
    savedStep = step
    selectedStep = step
  }

  func select(_ step: CaseStepOption) {
    selectedStep = step
  }

  func save() async {
    guard let step = selectedStep, hasChanges else { return }

    isSaving = true
    defer { isSaving = false }

    do {
      let success = try await repository.updateCaseStep(caseId: caseId, stepNumber: step.rawValue)
      if success {
        savedStep = step
        toastMessage = "Etapa actualizada"
      } else {
        toastMessage = "No se pudo actualizar la etapa"
      }
    } catch {
      debugPrint(error)
      toastMessage = "No se pudo actualizar la etapa"
    }
    showToast = true
  }
}
