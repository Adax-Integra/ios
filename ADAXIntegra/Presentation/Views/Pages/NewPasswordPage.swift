//
//  NewPasswordPage.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 06/10/26.
//

import SwiftUI

struct NewPasswordPage: View {
  @ObservedObject var viewModel: PasswordRecoveryViewModel

  var body: some View {
    AuthFormTemplate(title: "Ingresa nueva contraseña") {
      VStack(alignment: .leading, spacing: 6) {
        IconTextField(
          title: "Nueva contraseña",
          placeholder: "*************",
          systemIcon: "lock",
          isSecure: true,
          text: $viewModel.newPassword
        )
        Text(
          "Debe tener entre 8 y 24 caracteres, una mayúscula, una minúscula, un número y un carácter especial. No puede incluir acentos ni letras especiales."
        )
        .font(.caption)
        .foregroundStyle(.secondary)
        .fixedSize(horizontal: false, vertical: true)

        if let error = viewModel.passwordError {
          FieldErrorLabel(error)
        }
      }

      VStack(alignment: .leading, spacing: 6) {
        IconTextField(
          title: "Confirmar contraseña",
          placeholder: "*************",
          systemIcon: "lock",
          isSecure: true,
          text: $viewModel.confirmPassword
        )

        if let error = viewModel.confirmPasswordError {
          FieldErrorLabel(error)
        }
      }

      PrimaryButton(
        title: viewModel.isLoading ? "Guardando..." : "Continuar",
        isDisabled: viewModel.isLoading
      ) {
        Task { await viewModel.resetPassword() }
      }
    }

    // Error when changing the password
    .alert("Algo salió mal", isPresented: showGeneralError) {
      Button("Aceptar", role: .cancel) {}
    } message: {
      Text(viewModel.generalError ?? "")
    }

    // After changing the password, "Aceptar" closes the flow and goes back to the login

    .alert("Contraseña actualizada", isPresented: showSuccess) {
      Button("Aceptar", role: .cancel) {
        viewModel.finish()
      }
    } message: {
      Text(viewModel.successMessage ?? "")
    }
  }

  // Shows the general error whenever there is one

  private var showGeneralError: Binding<Bool> {
    Binding(
      get: { viewModel.generalError != nil },
      set: { if !$0 { viewModel.generalError = nil } }
    )
  }

  // Shows the alert while there is a success message

  private var showSuccess: Binding<Bool> {
    Binding(
      get: { viewModel.successMessage != nil },
      set: { if !$0 { viewModel.successMessage = nil } }
    )
  }

}

#Preview {
  NavigationStack {
    NewPasswordPage(viewModel: PasswordRecoveryViewModel())
  }
}
