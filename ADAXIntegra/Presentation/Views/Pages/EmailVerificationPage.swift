//
//  EmailVerificationPage.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 14/10/26.
//

import SwiftUI

struct EmailVerificationPage: View {
  @EnvironmentObject private var session: AuthSession
  @StateObject private var viewModel: EmailVerificationViewModel

  private let codeAlreadySent: Bool
  private let onBack: () -> Void

  // The view model needs the email so it is created here with it

  init(email: String, codeAlreadySent: Bool, onBack: @escaping () -> Void) {
    _viewModel = StateObject(wrappedValue: EmailVerificationViewModel(email: email))
    self.codeAlreadySent = codeAlreadySent
    self.onBack = onBack
  }

  var body: some View {
    CodeVerificationTemplate(
      description:
        "Enviamos un código de 6 dígitos a tu correo. Ingrésalo para completar tu registro.",
      maskedEmail: viewModel.maskedEmail,
      code: $viewModel.code,
      errorMessage: viewModel.codeError,
      secondsUntilResend: viewModel.secondsUntilResend,
      attempt: viewModel.currentAttempt,
      maxAttempts: viewModel.maxAttempts,
      canResend: viewModel.canResend,
      isResendLinkEnabled: viewModel.canResend,
      isVerifyDisabled: viewModel.isCodeLocked || viewModel.isLoading,
      verifyTitle: viewModel.isLoading ? "Verificando..." : "Verificar",
      backAction: onBack,
      onResendTapped: { Task { await viewModel.resendCode() } },
      onVerify: { Task { await viewModel.verifyCode() } }
    )
    .navigationBarBackButtonHidden(true)

    // Starts the countdown or requests a new code
    .task {
      await viewModel.start(codeAlreadySent: codeAlreadySent)
    }

    // Error that does not belong to the code

    .alert("Algo salió mal", isPresented: showGeneralError) {
      Button("Aceptar", role: .cancel) {}
    } message: {
      Text(viewModel.generalError ?? "")
    }

    // The account was verified before so she only needs to log in

    .alert("Tu cuenta ya está verificada", isPresented: $viewModel.isAlreadyVerified) {
      Button("Ir a iniciar sesión") {
        onBack()
      }
    } message: {
      Text("Inicia sesión con tu correo y contraseña.")
    }
    .navigationDestination(isPresented: showVerified) {
      EmailVerifiedPage(onContinue: continueToApp)
    }
  }

  // Shows the alert when there is a general error

  private var showGeneralError: Binding<Bool> {
    Binding(
      get: { viewModel.generalError != nil && viewModel.verifiedSession == nil },
      set: { if !$0 { viewModel.generalError = nil } }
    )
  }

  // Goes to "Cuenta verificada" when the backend returns the session

  private var showVerified: Binding<Bool> {
    Binding(
      get: { viewModel.verifiedSession != nil },
      set: { _ in }
    )
  }

  // Saves the session RootPage then shows the privacy notice and the home

  private func continueToApp() {
    guard let result = viewModel.verifiedSession else { return }
    session.login(with: result)
  }
}

#Preview {
  NavigationStack {
    EmailVerificationPage(email: "daniela@gmail.com", codeAlreadySent: true, onBack: {})
  }
  .environmentObject(AuthSession())
}
