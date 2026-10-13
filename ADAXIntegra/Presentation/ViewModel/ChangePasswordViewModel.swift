//
//  ChangePasswordViewModel.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 07/10/26.
//

import Combine
import Foundation

@MainActor
final class ChangePasswordViewModel: ObservableObject {
  @Published var currentPassword = ""
  @Published var newPassword = ""
  @Published var confirmPassword = ""
  @Published var passwordChanged = false
  @Published var isLoading = false
  @Published var errorMessage: String?

  private let changePasswordUseCase: ChangePasswordUseCaseProtocol

  init(changePasswordUseCase: ChangePasswordUseCaseProtocol? = nil) {
    self.changePasswordUseCase =
      changePasswordUseCase ?? ChangePasswordUseCase(dataRepository: RemoteAuthRepository())
  }

  // Same password policy as the registration screen
  var newPasswordError: String? {
    if newPassword.isEmpty {
      return nil
    }
    if newPassword.count < 8 || newPassword.count > 24 {
      return "Debe tener entre 8 y 24 caracteres."
    }
    if !newPassword.allSatisfy({ $0.isASCII }) {
      return "No puede incluir acentos ni letras especiales."
    }
    if newPassword.rangeOfCharacter(from: .uppercaseLetters) == nil {
      return "Debe incluir una mayúscula."
    }
    if newPassword.rangeOfCharacter(from: .lowercaseLetters) == nil {
      return "Debe incluir una minúscula."
    }
    if newPassword.rangeOfCharacter(from: .decimalDigits) == nil {
      return "Debe incluir un número."
    }
    if newPassword.rangeOfCharacter(from: .punctuationCharacters.union(.symbols)) == nil {
      return "Debe incluir un carácter especial."
    }
    if newPassword == currentPassword {
      return "Debe ser diferente a tu contraseña actual."
    }
    return nil
  }

  var confirmPasswordError: String? {
    if confirmPassword.isEmpty || confirmPassword == newPassword {
      return nil
    }
    return "Las contraseñas no coinciden."
  }

  var isFormValid: Bool {
    !currentPassword.isEmpty && !newPassword.isEmpty && !confirmPassword.isEmpty
      && newPasswordError == nil && confirmPasswordError == nil
  }

  func changePassword() async {
    isLoading = true
    errorMessage = nil

    do {
      _ = try await changePasswordUseCase.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword
      )
      passwordChanged = true
    } catch {
      handle(error)
    }

    isLoading = false
  }

  // The user is already logged in, so a 401 here means the current password did not match
  private func handle(_ error: Error) {
    guard case let APIError.server(statusCode, _) = error else {
      errorMessage = "No se pudo conectar con el servidor. Intenta de nuevo."
      return
    }

    switch statusCode {
    case 401:
      errorMessage = "La contraseña actual es incorrecta."
    default:
      errorMessage = "No se pudo cambiar la contraseña. Intenta de nuevo."
    }
  }
}
