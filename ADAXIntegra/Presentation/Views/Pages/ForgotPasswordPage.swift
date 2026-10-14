//
//  ForgotPasswordPage.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 07/10/26.
//

import SwiftUI

struct ForgotPasswordPage: View {
  @Environment(\.dismiss) private var dismiss
  @StateObject private var viewModel = PasswordRecoveryViewModel()

  var body: some View {
    AuthFormTemplate(title: "RECUPERAR CONTRASEÑA") {
      VStack(alignment: .leading, spacing: 6) {
        IconTextField(
          title: "Correo electrónico",
          placeholder: "tu@correo.com",
          systemIcon: "envelope",
          keyboard: .emailAddress,
          text: $viewModel.email
        )

        if let error = viewModel.emailError {
          FieldErrorLabel(error)
        }
      }

      PrimaryButton(
        title: viewModel.isLoading ? "Enviando..." : "Siguiente...",
        isDisabled: viewModel.isLoading
      ) {
        Task { await viewModel.resendCode() }
      }
    }
    // Out to return to the login if needed
    .overlay(alignment: .topLeading) {
      BackButton { dismiss() }
        .padding(16)
    }
    .navigationBarBackButtonHidden(true)

    .onTapGesture {
      hideKeyboard()
    }
    .navigationDestination(isPresented: $viewModel.showVerifyCode) {
      VerifyCodePage(viewModel: viewModel)
    }
    .alert("Contraseña actualizada", isPresented: showSuccess) {
      Button("Aceptar", role: .cancel) {
        viewModel.finish()
      }
    } message: {
      Text(viewModel.successMessage ?? "")
    }

    // first page of the full cover coling it will close the complete flow
    .onChange(of: viewModel.didFinish) { _, didFinish in
      if didFinish {
        dismiss
      }
    }
  }
  // shows the alert when there is a general error

  private var showGeneralError: Binding<Bool> {
    Binding(
      get: { viewModel.generalError != nil },
      set: { if !$0 { viewModel.generalError = nil } }
    )
  }

  // shows the alert when there is a success mesage

  private var showSuccess: Binding<Bool> {
    Binding(
      get: { viewModel.successMessage != nil },
      set: { if !$0 { viewModel.successMessage = nil } }
    )
  }

  private func hideKeyboard() {
    UIApplication.shared.sendAction(
      #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil
    )
  }
}

#Preview {
  NavigationStack {
    ForgotPasswordPage()
  }
}
