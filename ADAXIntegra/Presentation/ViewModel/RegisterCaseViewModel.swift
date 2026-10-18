//
//  RegisterCaseViewModel.swift
//  ADAXIntegra
//
//  R-11: Case registration for internal users and admins
//

import Combine
import Foundation

@MainActor
final class RegisterCaseViewModel: ObservableObject {
  // form fields
  @Published var caseDescription = ""
  @Published var helpDetails = ""
  @Published var hasExternalSupport = false

  @Published var showErrors = false
  @Published var isSaving = false
  @Published var showAlert = false
  @Published var errorMessage = ""

  private let externalID: String
  private let createCaseUseCase: CreateCaseUseCaseProtocol

  init(
    externalID: String,
    createCaseUseCase: CreateCaseUseCaseProtocol? = nil
  ) {
    self.externalID = externalID
    self.createCaseUseCase =
      createCaseUseCase
      ?? CreateCaseUseCase(dataRepository: RemoteCaseRepository())
  }

  // both fields must contain text before saving
  var isFormValid: Bool {
    !caseDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
      && !helpDetails.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }

  // show validation errors after attempting to save
  var caseDescriptionError: String? {
    showErrors && caseDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
      ? "Este campo es obligatorio" : nil
  }

  var helpDetailsError: String? {
    showErrors && helpDetails.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
      ? "Este campo es obligatorio" : nil
  }

  // register a new case for the selected external user
  func saveCase() async -> Bool {
    showErrors = true

    guard isFormValid && !isSaving else {
      return false
    }

    isSaving = true
    defer { isSaving = false }

    let newCase = NewCase(
      description: caseDescription,
      helpDetails: helpDetails,
      hasExternalSupport: hasExternalSupport
    )

    let caseId = await RemoteCaseRepository().createCaseForExternalUser(
      newCase,
      userId: externalID
    )

    guard caseId != nil else {
      errorMessage = "No se pudo registrar el caso. Intenta de nuevo."
      showAlert = true
      return false
    }

    return true
  }
}
