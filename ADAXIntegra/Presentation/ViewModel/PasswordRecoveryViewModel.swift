//
//  PasswordRecoveryViewModel.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 13/10/26.
//

import Combine
import Foundation

@MainActor
final class PasswordRecoveryViewModel: ObservableObject {

  // limits set by the backend

  let maxAttempts = 5
  private let maxSends = 3
  private let resendCooldown = 60

  // Form data editing a field clears the error the backend sent for it

  @Published var email = "" {
    didSet { emailServerError = nil }
  }
  @Published var code = "" {
    didSet { codeServerError = nil }
  }
  @Published var newPassword = "" {
    didSet { passwordServerError = nil }
  }
  @Published var confirmPassword = ""

  // Navigation between the pages

  @Published var showVerifyCode = false
  @Published var showNewPassword = false
  @Published var didFinish = false

  // Screen state

  @Published private(set) var isLoading = false
  @Published private(set) var secondsUntilResend = 0
  @Published private(set) var failedAttempts = 0
  @Published private var sendCount = 0
  @Published private var hasAttemptedEmail = false
  @Published private var hasAttemptedCode = false
  @Published private var hasAttemptedReset = false
  @Published private var emailServerError: String?
  @Published private var codeServerError: String?
  @Published private var passwordServerError: String?
  @Published var generalError: String?
  @Published var successMessage: String?

  private let requestCodeUseCase: RequestPasswordResetCodeUseCaseProtocol
  private let resetPasswordUseCase: ResetPasswordUseCaseProtocol
  private var countdownTask: Task<Void, Never>?
  private let required = "Este campo es obligatorio."

  init(
    requestCodeUseCase: RequestPasswordResetCodeUseCaseProtocol = RequestPasswordResetCodeUseCase(
      dataRepository: RemotePasswordRecoveryRepository()),
    resetPasswordUseCase: ResetPasswordUseCaseProtocol = ResetPasswordUseCase(
      dataRepository: RemotePasswordRecoveryRepository())
  ) {
    self.requestCodeUseCase = requestCodeUseCase
    self.resetPasswordUseCase = resetPasswordUseCase
  }

  // Errors only show after tapping the button of each page and update while typing

  var emailError: String? {
    if let emailServerError { return emailServerError }
    return hasAttemptedEmail ? validateEmail() : nil
  }

  var codeError: String? {
    if let codeServerError { return codeServerError }
    return hasAttemptedCode ? validateCode() : nil
  }

  var passwordError: String? {
    if let passwordServerError { return passwordServerError }
    return hasAttemptedReset ? validatePassword() : nil
  }

  var confirmPasswordError: String? {
    hasAttemptedReset ? validateConfirmPassword() : nil
  }

  // Shows the email hidden

  var maskedEmail: String {
    let clean = trimmedEmail
    guard let at = clean.firstIndex(of: "@"), at > clean.startIndex else { return clean }
    return "\(clean[clean.startIndex])••••••••\(clean[at...])"
  }

  // "Intento X de 5" shown under the code boxes

  var currentAttempt: Int {
    min(failedAttempts + 1, maxAttempts)
  }

  var isCodeLocked: Bool {
    failedAttempts >= maxAttempts
  }

  // The backend allows 3 emails in total, with 60 seconds between them

  var canResend: Bool {
    secondsUntilResend == 0 && sendCount < maxSends && !isLoading
  }

  // Called when tapping "Siguiente" on "Recuperar contraseña"

  func requestCode() async {
    hasAttemptedEmail = true
    generalError = nil
    guard validateEmail() == nil else { return }

    isLoading = true
    defer { isLoading = false }

    do {
      _ = try await requestCodeUseCase.requestResetCode(email: email)
      sendCount = 1
      prepareForNewCode()
      showVerifyCode = true
    } catch {
      print("Error al solicitar el código: ", error)
      handleRequestError(error)
    }
  }

  // Called when tapping "¿No recibiste el código?" on "Verifica tu cuenta"

  func resendCode() async {
    guard canResend else { return }

    isLoading = true
    defer { isLoading = false }

    do {
      _ = try await requestCodeUseCase.requestResetCode(email: email)
      sendCount += 1
      prepareForNewCode()
    } catch {
      print("Error al reenviar el código: ", error)
      handleRequestError(error)
    }
  }

  // Called when tapping "Verificar" the backend checks the code in the last step

  func verifyCode() {
    hasAttemptedCode = true
    guard validateCode() == nil, !isCodeLocked else { return }
    showNewPassword = true
  }

  // Called when tapping "Continuar" on "Ingresa nueva contraseña"

  func resetPassword() async {
    hasAttemptedReset = true
    generalError = nil
    guard validatePassword() == nil, validateConfirmPassword() == nil else { return }

    isLoading = true
    defer { isLoading = false }

    do {
      _ = try await resetPasswordUseCase.resetPassword(
        email: email, code: code, newPassword: newPassword)
      successMessage = "Tu contraseña se actualizó. Ya puedes iniciar sesión."
    } catch {
      print("Error al cambiar la contraseña: ", error)
      handleResetError(error)
    }
  }

  // Called after the success alert and closes the whole flow by going back to the login

  func finish() {
    countdownTask?.cancel()
    didFinish = true
  }

  // A new code replaces the old one, so the code and the wrong attempts start again

  private func prepareForNewCode() {
    code = ""
    failedAttempts = 0
    hasAttemptedCode = false
    startCountdown()
  }

  // Counts down from 60 to 0 before the code can be requested again

  private func startCountdown() {
    countdownTask?.cancel()
    secondsUntilResend = resendCooldown
    countdownTask = Task {
      while secondsUntilResend > 0 {
        try? await Task.sleep(for: .seconds(1))
        guard !Task.isCancelled else { return }
        secondsUntilResend -= 1
      }
    }
  }

  // Lets the user request a new code right away (expired or blocked code)

  private func stopCountdown() {
    countdownTask?.cancel()
    secondsUntilResend = 0
  }

  // Validations

  private var trimmedEmail: String {
    email.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  private func validateEmail() -> String? {
    let mail = trimmedEmail
    let pattern = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
    if mail.isEmpty { return required }
    if mail.range(of: pattern, options: [.regularExpression, .caseInsensitive]) == nil {
      return "Ingresa un correo válido."
    }
    return nil
  }

  private func validateCode() -> String? {
    if isCodeLocked { return "Demasiados intentos. Solicita un código nuevo." }
    if code.isEmpty { return required }
    if code.range(of: #"^\d{6}$"#, options: .regularExpression) == nil {
      return "El código debe tener 6 dígitos."
    }
    return nil
  }

  // Same password rules as the registration form

  private func validatePassword() -> String? {
    if newPassword.isEmpty { return required }
    if !isPasswordValid(newPassword) { return "La contraseña no cumple con los requisitos." }
    return nil
  }

  private func validateConfirmPassword() -> String? {
    if confirmPassword.isEmpty { return required }
    if confirmPassword != newPassword { return "Las contraseñas no coinciden." }
    return nil
  }

  // 8 to 24 characters, an uppercase and a lowercase letter, a number, a special character, and no accents or special letters

  private func isPasswordValid(_ password: String) -> Bool {
    (8...24).contains(password.count)
      && password.rangeOfCharacter(from: .uppercaseLetters) != nil
      && password.rangeOfCharacter(from: .lowercaseLetters) != nil
      && password.rangeOfCharacter(from: .decimalDigits) != nil
      && password.rangeOfCharacter(from: .punctuationCharacters.union(.symbols)) != nil
      && password.allSatisfy(\.isASCII)
  }

  // Backend errors

  private func decode(_ data: Data?) -> APIErrorResponse? {
    data.flatMap { try? JSONDecoder().decode(APIErrorResponse.self, from: $0) }
  }

  // Errors when requesting or resending the code

  private func handleRequestError(_ error: Error) {
    guard case let APIError.server(statusCode, data) = error else {
      generalError = "No se pudo conectar con el servidor. Intenta de nuevo."
      return
    }

    let body = decode(data)

    switch statusCode {
    case 400:
      emailServerError = body?.error ?? "Ingresa un correo válido."
    case 429:
      generalError = "Demasiadas solicitudes. Espera un momento e intenta de nuevo."
    default:
      generalError = "No se pudo enviar el código. Intenta de nuevo."
    }
  }

  // Errors when changing the password; code errors send the user back to "Verifica tu cuenta"

  private func handleResetError(_ error: Error) {
    guard case let APIError.server(statusCode, data) = error else {
      generalError = "No se pudo conectar con el servidor. Intenta de nuevo."
      return
    }

    let body = decode(data)

    switch body?.code {
    case "CODE_INVALID":
      failedAttempts += 1
      codeServerError =
        isCodeLocked ? "Demasiados intentos. Solicita un código nuevo." : "Código incorrecto."
      if isCodeLocked { stopCountdown() }
      showNewPassword = false
    case "CODE_EXPIRED":
      codeServerError = "El código expiró. Solicita uno nuevo."
      stopCountdown()
      showNewPassword = false
    case "TOO_MANY_ATTEMPTS":
      failedAttempts = maxAttempts
      codeServerError = "Demasiados intentos. Solicita un código nuevo."
      stopCountdown()
      showNewPassword = false
    case "VALIDATION_ERROR":
      passwordServerError = body?.error ?? "La contraseña no cumple con los requisitos."
    default:
      generalError =
        statusCode == 429
        ? "Demasiadas solicitudes. Espera un momento e intenta de nuevo."
        : "No se pudo cambiar la contraseña. Intenta de nuevo."
    }
  }
}
