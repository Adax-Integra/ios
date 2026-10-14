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
        Task { await viewModel.requestCode() }
      }
    }
    // Out to return to the login if needed
    .overlay(alignment: .topLeading) {
      BackButton { dismiss() }
        .padding(16)
    }
    .navigationBarBackButtonHidden(true)

    // Error when resending the code

    .alert("Algo salió mal", isPresented: showGeneralError) {
      Button("Aceptar", role: .cancel) {}
    } message: {
      Text(viewModel.generalError ?? "")
    }

    .onTapGesture {
      hideKeyboard()
    }
    .navigationDestination(isPresented: $viewModel.showVerifyCode) {
      VerifyCodePage(viewModel: viewModel)
    }

    // first page of the full cover coling it will close the complete flow
    .onChange(of: viewModel.didFinish) { _, didFinish in
      if didFinish {
        dismiss()
      }
    }
  }
  // shows the alert when there is a general error

  private var showGeneralError: Binding<Bool> {
    Binding(
      get: { viewModel.generalError != nil && !viewModel.showVerifyCode },
      set: { if !$0 { viewModel.generalError = nil } }
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
