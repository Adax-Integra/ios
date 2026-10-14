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
  // Turned on by the "Crear caso" tap, so empty fields
  // are not marked as errors before the user tries to create a case
  @Published var showErrors = false

  var createCaseUseCase: CreateCaseUseCaseProtocol
  private let userId: String

  // Case confirmed by the user but not sent yet: it waits until the undo toast closes.
  // "Deshacer" only needs to discard it, because nothing reached the backend
  private var pendingCase: NewCase?

  init(
    userId: String,
    createCaseUseCase: CreateCaseUseCaseProtocol? = nil
  ) {
    self.userId = userId
    // Built here instead of as a default argument so it runs on the main actor
    self.createCaseUseCase =
      createCaseUseCase ?? CreateCaseUseCase(dataRepository: RemoteCaseRepository())
  }

  // Both text fields need content besides spaces before the confirmation opens
  var isFormValid: Bool {
    !caseDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
      && !helpDetails.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }

  // Error messages for each field. They are computed,
  // so they disappear as soon as the user writes in the field
  var caseDescriptionError: String? { requiredError(caseDescription) }
  var helpDetailsError: String? { requiredError(helpDetails) }

  private func requiredError(_ value: String) -> String? {
    guard showErrors else { return nil }
    return value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
      ? "Este campo es obligatorio" : nil
  }

  func onCreateTapped() {
    // The button is always enabled, so the first tap reveals the invalid fields
    showErrors = true
    guard isFormValid else { return }
    isShowingConfirmation = true
  }

  // Stores the case and opens the undo window instead of sending it right away
  func onConfirm() {
    isShowingConfirmation = false
    pendingCase = NewCase(
      description: caseDescription,
      helpDetails: helpDetails,
      hasExternalSupport: hasExternalSupport
    )
    isShowingUndoToast = true
  }

  func onUndo() {
    pendingCase = nil
  }

  // Called by CasesPage when the undo toast closes or the list disappears.
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
    showErrors = false
  }
}
