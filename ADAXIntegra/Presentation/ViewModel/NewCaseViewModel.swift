//
//  NewCaseViewModel.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 23/09/26.
//

import Combine
import Foundation

// Handles the "Nuevo caso" screen: form state, confirmation, undo window and submission
@MainActor
final class NewCaseViewModel: ObservableObject {

  // Form fields
  @Published var caseDescription = ""
  @Published var helpDetails = ""
  @Published var hasExternalSupport = false

  // UI state
  @Published var isShowingConfirmation = false
  @Published var isShowingUndoToast = false
  @Published var isShowingExternalSupportInfo = false
  @Published var messageAlert = ""
  @Published var showAlert = false

  var createCaseUseCase: CreateCaseUseCaseProtocol
  private let userId: String

  // Case confirmed by the user but not sent yet: it waits until the undo toast closes.
  // "Deshacer" only needs to discard it, because nothing reached the backend
  private var pendingCase: CaseEntity?

  init(
    userId: String,
    createCaseUseCase: CreateCaseUseCaseProtocol? = nil
  ) {
    self.userId = userId
    // Built here instead of as a default argument so it runs on the main actor
    self.createCaseUseCase =
      createCaseUseCase ?? CreateCaseUseCase(dataRepository: RemoteCreateCaseRepository.shared)
  }

  // Enable "Crear caso" only when both text fields have content besides spaces
  var isFormValid: Bool {
    !caseDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
      && !helpDetails.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }

  func onCreateTapped() {
    guard isFormValid else { return }
    isShowingConfirmation = true
  }

  // Stores the case and opens the undo window instead of sending it right away
  func onConfirm() {
    isShowingConfirmation = false
    pendingCase = CaseEntity(
      description: caseDescription,
      helpDetails: helpDetails,
      hasExternalSupport: hasExternalSupport
    )
    isShowingUndoToast = true
  }

  func onUndo() {
    pendingCase = nil
  }

  // Called by the View when the toast closes or the screen disappears.
  // Clearing pendingCase first prevents sending the same case twice
  func sendPendingCase() async {
    guard let newCase = pendingCase else { return }
    pendingCase = nil

    if await createCaseUseCase.createCase(newCase, userId: userId) != nil {
      resetForm()
    } else {
      // The form keeps its content so the user can retry without rewriting
      messageAlert = "No pudimos registrar tu caso. Revisa tu conexión e intenta de nuevo."
      showAlert = true
    }
  }

  private func resetForm() {
    caseDescription = ""
    helpDetails = ""
    hasExternalSupport = false
  }
}
