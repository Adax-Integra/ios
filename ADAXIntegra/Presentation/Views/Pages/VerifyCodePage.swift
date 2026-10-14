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
    ZStack {
      Color("Background").ignoresSafeArea()

      VStack(alignment: .leading, spacing: 20) {
        PageHeader(title: "Verifica tu cuenta", backAction: { dismiss() })

        VStack(alignment: .leading, spacing: 6) {
          Text(
            "Enviamos un código de 6 dígitos a tu correo. Ingrésalo para recuperar tu contraseña. Si no lo ves, revisa tu carpeta de spam."
          )
          .font(.system(size: 15))
          .foregroundColor(Color("OnBackground"))
          .lineSpacing(3)

          Text("Si no lo ves, revisa tu carpeta de spam.")
            .font(.system(size: 13))
            .foregroundColor(Color("IconColor"))
        }
        .fixedSize(horizontal: false, vertical: true)

        CodeSentCard(email: viewModel.maskedEmail)

        VerificationCodeCard(
          code: $viewModel.code,
          errorMessage: viewModel.codeError,
          secondsUntilResend: viewModel.secondsUntilResend,
          attempt: viewModel.currentAttempt,
          maxAttempts: viewModel.maxAttempts,
          canResend: viewModel.canResend
        )

        // Resend the code becomes able when the coutdown becomes 0 and is not blocked by the limit of attemps

        Button {
          Task { await viewModel.resendCode() }
        } label: {
          Text("¿No recibiste el código?")
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(viewModel.canResend ? Color("PrimaryAdax") : Color("IconColor"))
            .underline(viewModel.canResend)
        }
        .buttonStyle(.plain)
        .disabled(!viewModel.canResend)
        .frame(maxWidth: .infinity)

        Spacer()

        // The button is disabled after 5 wrong attempts

        PrimaryButton(title: "Verificar", isDisabled: viewModel.isCodeLocked) {
          viewModel.verifyCode()
        }
      }

      .padding()
    }
    .navigationBarBackButtonHidden(true)

    // Error  when resending the code
    .alert("Algo salió mal", isPresented: showGeneralError) {
      Button("Aceptar", role: .cancel) {}
    } message: {
      Text(viewModel.generalError ?? "")
    }

    .onTapGesture {
      hideKeyboard()
    }
    .navigationDestination(isPresented: $viewModel.showNewPassword) {
      NewPasswordPage(viewModel: viewModel)
    }
  }

  // closes the keyboard when typing outside the fields

  private func hideKeyboard() {
    UIApplication.shared.sendAction(
      #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil
    )
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
