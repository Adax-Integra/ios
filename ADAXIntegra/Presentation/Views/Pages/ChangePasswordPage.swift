//
//  ChangePasswordPage.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 07/10/26.
//

import SwiftUI

struct ChangePasswordPage: View {
  @Environment(\.dismiss) private var dismiss
  @StateObject private var viewModel = ChangePasswordViewModel()
  @State private var showConfirmation = false

  var body: some View {
    ZStack {
      Color("Background").ignoresSafeArea()

      VStack(alignment: .leading, spacing: 16) {
        PageHeader(
          title: "Cambiar contraseña",
          backAction: { dismiss() },
          subtitle: "Seguridad"
        )

        ScrollView {
          VStack(alignment: .leading, spacing: 16) {
            Text("Para proteger tu expediente, confirma primero tu contraseña actual.")
              .font(.subheadline)
              .foregroundColor(Color("OnBackground"))

            PasswordTextField(
              title: "Contraseña actual",
              placeholder: "Escribe tu contraseña actual",
              text: $viewModel.currentPassword
            )

            VStack(alignment: .leading, spacing: 6) {
              PasswordTextField(
                title: "Nueva contraseña",
                placeholder: "Entre 8 y 24 caracteres",
                text: $viewModel.newPassword
              )
              if let error = viewModel.newPasswordError {
                FieldErrorLabel(error)
              }
            }

            VStack(alignment: .leading, spacing: 6) {
              PasswordTextField(
                title: "Confirmar nueva contraseña",
                placeholder: "Escríbela de nuevo",
                text: $viewModel.confirmPassword
              )
              if let error = viewModel.confirmPasswordError {
                FieldErrorLabel(error)
              }
            }

            VStack(alignment: .leading, spacing: 6) {
              Text("Tu nueva contraseña debe tener:")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(Color("OnBackground"))

              Text("· Diferente a la contraseña actual")
                .font(.subheadline)
                .foregroundColor(Color("InsideTextAndIcons"))

              Text("· Entre 8 y 24 caracteres")
                .font(.subheadline)
                .foregroundColor(Color("InsideTextAndIcons"))

              Text("· Una mayúscula y una minúscula")
                .font(.subheadline)
                .foregroundColor(Color("InsideTextAndIcons"))

              Text("· Al menos un número")
                .font(.subheadline)
                .foregroundColor(Color("InsideTextAndIcons"))

              Text("· Al menos un carácter especial (! # $ …)")
                .font(.subheadline)
                .foregroundColor(Color("InsideTextAndIcons"))

              Text("· Sin acentos ni letras especiales (ñ, ç, æ…)")
                .font(.subheadline)
                .foregroundColor(Color("InsideTextAndIcons"))

              Text("· Las contraseñas deben coincidir")
                .font(.subheadline)
                .foregroundColor(Color("InsideTextAndIcons"))
            }
          }
        }
        .scrollDismissesKeyboard(.interactively)

        PrimaryButton(
          title: viewModel.isLoading ? "Guardando..." : "Cambiar contraseña",
          isDisabled: !viewModel.isFormValid || viewModel.isLoading,
          action: {
            dismissKeyboard()
            showConfirmation = true
          }
        )
      }
      .padding()
    }
    .navigationBarBackButtonHidden(true)
    .alert("Cambiar contraseña", isPresented: $showConfirmation) {
      Button("Guardar") {
        Task { await viewModel.changePassword() }
      }
      Button("Cancelar", role: .cancel) {}
    } message: {
      Text("¿Quieres guardar tu nueva contraseña?")
    }
    .alert("No se pudo cambiar la contraseña", isPresented: showError) {
      Button("Aceptar", role: .cancel) {}
    } message: {
      Text(viewModel.errorMessage ?? "")
    }
    .alert("Contraseña actualizada", isPresented: $viewModel.passwordChanged) {
      Button("Aceptar") { dismiss() }
    } message: {
      Text("Tu contraseña se cambió con éxito.")
    }
  }

  // Shows the alert while there is an error and clears it when it is closed
  private var showError: Binding<Bool> {
    Binding(
      get: { viewModel.errorMessage != nil },
      set: { if !$0 { viewModel.errorMessage = nil } }
    )
  }

  // Closes the keyboard before the confirmation alert, same as NewCasePage
  private func dismissKeyboard() {
    UIApplication.shared.sendAction(
      #selector(UIResponder.resignFirstResponder),
      to: nil,
      from: nil,
      for: nil
    )
  }
}

#Preview {
  ChangePasswordPage()
}
