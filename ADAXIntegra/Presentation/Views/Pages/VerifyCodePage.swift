//
//  VerifyCodePage.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 06/10/26.
//
import SwiftUI

struct VerifyCodePage: View {
  @Environment(\.dismiss) private var dismiss
  @ObservedObject var viewModel: PasswordRecoveryViewModel

  var body: some View {
    CodeVerificationTemplate(
      description:
        "Enviamos un código de 6 dígitos a tu correo. Ingrésalo para recuperar tu contraseña.",
      maskedEmail: viewModel.maskedEmail,
      code: $viewModel.code,
      errorMessage: viewModel.codeError,
      secondsUntilResend: viewModel.secondsUntilResend,
      attempt: viewModel.currentAttempt,
      maxAttempts: viewModel.maxAttempts,
      canResend: viewModel.canResend,
      // G-05 resends directly so the link is only enabled when the time has passed
      isResendLinkEnabled: viewModel.canResend,
      isVerifyDisabled: viewModel.isCodeLocked,
      backAction: { dismiss() },
      onResendTapped: { Task { await viewModel.resendCode() } },
      onVerify: { viewModel.verifyCode() }
    )

    .navigationBarBackButtonHidden(true)

    // Error  when resending the code
    .alert("Algo salió mal", isPresented: showGeneralError) {
      Button("Aceptar", role: .cancel) {}
    } message: {
      Text(viewModel.generalError ?? "")
    }

    .navigationDestination(isPresented: $viewModel.showNewPassword) {
      NewPasswordPage(viewModel: viewModel)
    }
  }

  private var showGeneralError: Binding<Bool> {
    Binding(
      get: { viewModel.generalError != nil && !viewModel.showNewPassword },
      set: { if !$0 { viewModel.generalError = nil } }
    )
  }
}

#Preview {
  NavigationStack {
    VerifyCodePage(viewModel: PasswordRecoveryViewModel())
  }
}
