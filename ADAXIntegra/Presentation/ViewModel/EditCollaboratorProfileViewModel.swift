//
//  EditCollaboratorProfileViewModel.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 17/10/26.
//

import Combine
import Foundation

@MainActor
final class EditCollaboratorProfileViewModel: ObservableObject {
  static let maxNameLength = 50
  static let maxEmailLength = 128

  @Published var name = ""
  @Published var lastName = ""
  @Published var email = ""

  @Published var showErrors = false

  @Published private(set) var isLoading = false
  @Published private(set) var isSaving = false
  @Published var isShowingConfirmation = false
  @Published var errorMessage: String?
  @Published private(set) var loadErrorMessage: String?
  @Published private(set) var didSave = false
  @Published var wantsDismiss = false

  private var savedName = ""
  private var savedLastName = ""
  private var savedEmail = ""

  private var takenEmail: String?

  private let userId: String
  private let getUseCase: GetCollaboratorProfileUseCaseProtocol
  private let updateUseCase: UpdateCollaboratorProfileUseCaseProtocol

  init(
    userId: String,
    getUseCase: GetCollaboratorProfileUseCaseProtocol? = nil,
    updateUseCase: UpdateCollaboratorProfileUseCaseProtocol? = nil
  ) {
    self.userId = userId
    let repository = RemoteCollaboratorProfileRepository()
    self.getUseCase = getUseCase ?? GetCollaboratorProfileUseCase(dataRepository: repository)
    self.updateUseCase =
      updateUseCase ?? UpdateCollaboratorProfileUseCase(dataRepository: repository)
  }

  var displayName: String {
    let full = "\(savedName) \(savedLastName)".trimmingCharacters(in: .whitespaces)
    return full.isEmpty ? "Sin nombre" : full
  }

  var nameError: String? {
    guard showErrors, clean(name) != clean(savedName) else { return nil }
    return nameProblem(clean(name), field: "nombre")
  }

  var lastNameError: String? {
    guard showErrors, clean(lastName) != clean(savedLastName) else { return nil }
    return nameProblem(clean(lastName), field: "apellidos")
  }

  var emailError: String? {
    guard showErrors else { return nil }
    return emailProblem
  }

  var hasChanges: Bool {
    clean(name) != clean(savedName)
      || clean(lastName) != clean(savedLastName)
      || cleanEmail(email) != cleanEmail(savedEmail)
  }

  var emailChanged: Bool {
    cleanEmail(email) != cleanEmail(savedEmail)
  }

  var changes: [CollaboratorProfileChange] {
    var result: [CollaboratorProfileChange] = []
    if clean(name) != clean(savedName) {
      result.append(
        CollaboratorProfileChange(
          label: "Nombre(s)", oldValue: shown(savedName), newValue: shown(name)))
    }
    if clean(lastName) != clean(savedLastName) {
      result.append(
        CollaboratorProfileChange(
          label: "Apellidos", oldValue: shown(savedLastName), newValue: shown(lastName)))
    }
    if emailChanged {
      result.append(
        CollaboratorProfileChange(
          label: "Correo electrónico", oldValue: shown(savedEmail), newValue: cleanEmail(email)))
    }
    return result
  }

  var isFormValid: Bool {
    nameProblemIfChanged == nil
      && lastNameProblemIfChanged == nil
      && emailProblem == nil
      && hasChanges
  }

  func load() async {
    guard !isLoading else { return }
    isLoading = true
    loadErrorMessage = nil
    defer { isLoading = false }

    do {
      let profile = try await getUseCase.getCollaboratorProfile(for: userId)
      apply(profile)
    } catch {
      loadErrorMessage = "No se pudo cargar la información de la colaboradora."
    }
  }

  func onSaveTapped() {
    guard hasChanges else {
      wantsDismiss = true
      return
    }
    showErrors = true
    guard isFormValid else { return }
    isShowingConfirmation = true
  }

  func confirm() async {
    isShowingConfirmation = false
    isSaving = true
    errorMessage = nil

    do {
      _ = try await updateUseCase.updateCollaboratorProfile(for: userId, with: makeRequest())
      didSave = true
    } catch {
      handle(error)
    }

    isSaving = false
  }

  private func apply(_ profile: CollaboratorProfile) {
    savedName = profile.name ?? ""
    savedLastName = profile.lastName ?? ""
    savedEmail = profile.email ?? ""
    name = savedName
    lastName = savedLastName
    email = savedEmail
    takenEmail = nil
    showErrors = false
  }

  private func makeRequest() -> UpdateCollaboratorProfileRequest {
    let newName = clean(name)
    let newLastName = clean(lastName)
    let newEmail = cleanEmail(email)

    let changes = UpdateCollaboratorProfileRequest.ProfileChanges(
      name: newName != clean(savedName) ? newName : nil,
      lastName: newLastName != clean(savedLastName) ? newLastName : nil,
      email: newEmail != cleanEmail(savedEmail) ? newEmail : nil
    )

    return UpdateCollaboratorProfileRequest(profile: changes)
  }

  private var nameProblemIfChanged: String? {
    guard clean(name) != clean(savedName) else { return nil }
    return nameProblem(clean(name), field: "nombre")
  }

  private var lastNameProblemIfChanged: String? {
    guard clean(lastName) != clean(savedLastName) else { return nil }
    return nameProblem(clean(lastName), field: "apellidos")
  }

  private func nameProblem(_ value: String, field: String) -> String? {
    if value.isEmpty { return "El campo \(field) es obligatorio" }
    if value.count > Self.maxNameLength {
      return "Máximo \(Self.maxNameLength) caracteres"
    }
    return nil
  }

  private var emailProblem: String? {
    let value = cleanEmail(email)
    guard value != cleanEmail(savedEmail) else { return nil }
    if value.range(of: #"^[^\s@]+@[^\s@]+\.[^\s@]+$"#, options: .regularExpression) == nil {
      return "Ingresa un correo electrónico válido"
    }
    if value.count > Self.maxEmailLength {
      return "Máximo \(Self.maxEmailLength) caracteres"
    }
    if value == takenEmail {
      return "Este correo ya está registrado en otra cuenta."
    }
    return nil
  }

  private func handle(_ error: Error) {
    guard case APIError.server(let statusCode, _) = error else {
      errorMessage = "No pudimos guardar los cambios. Revisa tu conexión e intenta de nuevo."
      return
    }

    switch statusCode {
    case 409:
      takenEmail = cleanEmail(email)
      showErrors = true
    case 403: errorMessage = "No tienes permiso para modificar estos datos."
    case 404: errorMessage = "La cuenta de la colaboradora no está disponible."
    case 400: errorMessage = "Revisa los datos e intenta de nuevo."
    default: errorMessage = "No pudimos guardar los cambios. Intenta de nuevo más tarde."
    }
  }

  private func cleanEmail(_ value: String) -> String {
    clean(value).lowercased()
  }

  private func clean(_ value: String) -> String {
    value.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  private func shown(_ value: String) -> String {
    let text = clean(value)
    return text.isEmpty ? "Sin dato" : text
  }
}

struct CollaboratorProfileChange: Identifiable {
  let id = UUID()
  let label: String
  let oldValue: String
  let newValue: String
}
