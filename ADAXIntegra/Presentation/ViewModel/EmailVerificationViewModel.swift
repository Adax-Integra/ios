//
//  EmailVerificationViewModel.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 14/10/26.
//

import Combine
import Foundation

// State and logic of "Verifica tu cuenta" for a new account

@MainActor
final class EmailVerificationViewModel: ObservableObject {

  // Limits set by the backend

  let maxAttempts = 5
  private let maxSends = 3
  private let resendCooldown = 60

  // Email of the account to verify (from the registration or the login)

  let email: String

  // Editing the code clears the error the backend sent for it

  @Published var code = "" {
    didSet { codeServerError = nil }
  }

  // Screen state

  @Published private(set) var isLoading = false
  @Published private(set) var secondsUntilResend = 0
  @Published private(set) var failedAttempts = 0
  @Published private var sendCount = 0
  @Published private var hasAttemptedVerify = false
  @Published private var codeServerError: String?
  @Published var generalError: String?

  // Session returned by the backend when the code is right when it  shows "Cuenta verificada"

  @Published var verifiedSession: LoginResult?

  // True when the account was already verified when the page sends the user to the login

  @Published var isAlreadyVerified = false

  private let verifyEmailUseCase: VerifyEmailUseCaseProtocol
  private let resendVerificationUseCase: ResendVerificationUseCaseProtocol
  private var countdownTask: Task<Void, Never>?
  private let tooManyAttempts = "Demasiados intentos. Solicita un código nuevo."

  init(
    email: String,
    verifyEmailUseCase: VerifyEmailUseCaseProtocol = VerifyEmailUseCase(
      dataRepository: RemoteEmailVerificationRepository()),
    resendVerificationUseCase: ResendVerificationUseCaseProtocol = ResendVerificationUseCase(
      dataRepository: RemoteEmailVerificationRepository())
  ) {
    self.email = email
    self.verifyEmailUseCase = verifyEmailUseCase
    self.resendVerificationUseCase = resendVerificationUseCase
  }

  // The error only shows after tapping "Verificar" then it updates while typing

  var codeError: String? {
    if let codeServerError { return codeServerError }
    return hasAttemptedVerify ? validateCode() : nil
  }

  // Shows the email hidden "d••••••••@gmail.com"

  var maskedEmail: String {
    let clean = email.trimmingCharacters(in: .whitespacesAndNewlines)
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

  // The backend allows 3 emails in total with 60 seconds between them

  var canResend: Bool {
    secondsUntilResend == 0 && sendCount < maxSends && !isLoading
  }

  // Called when the page opens and  after the registration the code was just sent

  func start(codeAlreadySent: Bool) async {
    guard sendCount == 0 else { return }

    if codeAlreadySent {
      sendCount = 1
      startCountdown()
    } else {
      await sendCode()
    }
  }

  // Called when tapping "¿No recibiste el código?"

  func resendCode() async {
    guard canResend else { return }
    await sendCode()
  }

  // Called when tapping "Verificar"

  func verifyCode() async {
    hasAttemptedVerify = true
    generalError = nil
    guard validateCode() == nil else { return }

    isLoading = true
    defer { isLoading = false }

    do {
      verifiedSession = try await verifyEmailUseCase.verifyEmail(email: email, code: code)
      countdownTask?.cancel()
    } catch {
      print("Error al verificar el correo: ", error)
      handleVerifyError(error)
    }
  }

  // Requests a code and starts the countdown

  private func sendCode() async {
    isLoading = true
    defer { isLoading = false }

    do {
      _ = try await resendVerificationUseCase.resendVerification(email: email)
      sendCount += 1
      prepareForNewCode()
    } catch {
      print("Error al enviar el código: ", error)
      handleResendError(error)
    }
  }

  // A new code replaces the old one, so the code and the wrong attempts start again

  private func prepareForNewCode() {
    code = ""
    failedAttempts = 0
    hasAttemptedVerify = false
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

  // Lets the user request a new code right away

  private func stopCountdown() {
    countdownTask?.cancel()
    secondsUntilResend = 0
  }

  private func validateCode() -> String? {
    if isCodeLocked { return tooManyAttempts }
    if code.isEmpty { return "Este campo es obligatorio." }
    if code.range(of: #"^\d{6}$"#, options: .regularExpression) == nil {
      return "El código debe tener 6 dígitos."
    }
    return nil
  }

  // Backend errors

  private func decode(_ data: Data?) -> APIErrorResponse? {
    data.flatMap { try? JSONDecoder().decode(APIErrorResponse.self, from: $0) }
  }

  // Errors when checking the code

  private func handleVerifyError(_ error: Error) {
    guard case let APIError.server(statusCode, data) = error else {
      generalError = "No se pudo conectar con el servidor. Intenta de nuevo."
      return
    }

    switch decode(data)?.code {
    case "CODE_INVALID":
      failedAttempts += 1
      codeServerError = isCodeLocked ? tooManyAttempts : "Código incorrecto."
      if isCodeLocked { stopCountdown() }
    case "CODE_EXPIRED":
      codeServerError = "El código expiró. Solicita uno nuevo."
      stopCountdown()
    case "TOO_MANY_ATTEMPTS":
      failedAttempts = maxAttempts
      codeServerError = tooManyAttempts
      stopCountdown()
    case "ALREADY_VERIFIED":
      isAlreadyVerified = true
    default:
      generalError =
        statusCode == 429
        ? "Demasiadas solicitudes. Espera un momento e intenta de nuevo."
        : "No se pudo verificar el código. Intenta de nuevo."
    }
  }

  // Errors when requesting a code. Unlike the G-05, this endpoint reports its limits

  private func handleResendError(_ error: Error) {
    guard case let APIError.server(statusCode, data) = error else {
      generalError = "No se pudo conectar con el servidor. Intenta de nuevo."
      return
    }

    switch decode(data)?.code {
    case "RESEND_TOO_SOON":
      // A code was sent less than a minute ago so the user only has to wait
      sendCount = max(sendCount, 1)
      startCountdown()
    case "TOO_MANY_SENDS":
      sendCount = maxSends
      generalError =
        "Llegaste al límite de reenvíos. Usa el último código que recibiste o inténtalo más tarde."
    default:
      generalError =
        statusCode == 429
        ? "Demasiadas solicitudes. Espera un momento e intenta de nuevo."
        : "No se pudo enviar el código. Intenta de nuevo."
    }
  }
}
