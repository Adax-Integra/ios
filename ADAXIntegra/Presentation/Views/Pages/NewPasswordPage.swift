//
//  NewPasswordPage.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 06/10/26.
//

import SwiftUI

struct NewPasswordPage: View {
  @Environment(\.dismiss) private var dismiss
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

    .overlay(alignment: .topLeading) {
      BackButton { dismiss() }
        .padding(16)
    }
    .navigationBarBackButtonHidden(true)
    // Hides the keyboard when tapping outside the box
    .onTapGesture {
      hideKeyboard()
    }
  }

  // Closes the keyboard when something is selected
  private func hideKeyboard() {
    UIApplication.shared.sendAction(
      #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil
    )
  }
}

#Preview {
  NavigationStack {
    NewPasswordPage(viewModel: PasswordRecoveryViewModel())
  }
}
