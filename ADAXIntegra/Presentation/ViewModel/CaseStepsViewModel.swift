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
  @Published private(set) var isEditing = false
  @Published private(set) var isSaving = false
  @Published var showToast = false
  @Published var toastMessage = ""
  // shows the success page after saving, the toast is only for errors
  @Published var isShowingSuccess = false

  private let repository: CaseRepository
  private let caseId: String

  init(caseId: String, repository: CaseRepository = RemoteCaseRepository()) {
    self.caseId = caseId
    self.repository = repository
  }

  // Hay cambios cuando eligió una etapa distinta a la guardada
  var hasChanges: Bool { selectedStep != nil && selectedStep != savedStep }

  // Se llama una vez que el detalle del caso ya cargó
  func setInitial(stepNumber: Int?) {
    let step = stepNumber.flatMap { CaseStepOption(rawValue: $0) }
    savedStep = step
    selectedStep = step
    isEditing = false
  }

  func isSelected(id: String) -> Bool {
    selectedStep.map { String($0.rawValue) } == id
  }

  func toggle(id: String) {
    guard isEditing, let number = Int(id), let step = CaseStepOption(rawValue: number) else {
      return
    }
    selectedStep = step
  }

  func startEditing() {
    isEditing = true
  }

  func cancelEditing() {
    selectedStep = savedStep
    isEditing = false
  }

  func save() async {
    guard let step = selectedStep, hasChanges else { return }

    isSaving = true
    defer { isSaving = false }

    do {
      let success = try await repository.updateCaseStep(caseId: caseId, stepNumber: step.rawValue)
      if success {
        savedStep = step
        isEditing = false
        isShowingSuccess = true
      } else {
        toastMessage = "No se pudo actualizar la etapa"
        showToast = true
      }
    } catch APIError.server(let statusCode, let data) {
      let body = String(data: data ?? Data(), encoding: .utf8) ?? ""
      debugPrint("Etapa falló. Status: \(statusCode). Respuesta: \(body)")
      toastMessage = "No se pudo actualizar la etapa"
      showToast = true
    } catch {
      debugPrint(error)
      toastMessage = "No se pudo actualizar la etapa"
      showToast = true
    }
  }
}
