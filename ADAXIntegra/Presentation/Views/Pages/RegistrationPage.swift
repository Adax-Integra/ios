//
//  RegistrationPage.swift
//  ADAXIntegra
//
//  Created by Lakshmi Jara on 22/09/26.
//

import SwiftUI

// page that manages the registration form state and actions
struct RegistrationPage: View {
  @Environment(\.dismiss) private var dismiss  // return to previous screen
  @StateObject private var viewModel = RegistrationViewModel()  // handles account creation and stores any error message

  // local state for the registration form
  @State private var name = ""
  @State private var lastName = ""
  @State private var email = ""
  @State private var countryCode: String? = "+52"
  @State private var phoneNumber = ""
  @State private var password = ""
  @State private var confirmPassword = ""
  // G-09: opens "Verifica tu cuenta" agert the account is created
  @State private var showVerification = false

  var body: some View {
    RegistrationTemplate(
      name: $name,
      lastName: $lastName,
      email: $email,
      countryCode: $countryCode,
      phoneNumber: $phoneNumber,
      password: $password,
      confirmPassword: $confirmPassword,
      countries: viewModel.countries,
      backAction: {
        dismiss()
      },
      registerAction: {
        guard let countryCode else {
          return
        }
        // calls the account creation method
        // sends the values from the form to the ViewModel
        Task {
          await viewModel.createAccount(  // waits for the account method to finish
            name: name,
            lastName: lastName,
            email: email,
            countryCode: countryCode,
            phone: phoneNumber,
            password: password,
            confirmPassword: confirmPassword
          )

          // G-09: the backend already emailed the code, so she verifies her account now
          if viewModel.accountCreated {
            showVerification = true
          }
        }
      }
    )
    .task {
      await viewModel.loadCountries()
    }
    .alert(
      "No se pudo crear la cuenta.",
      isPresented: Binding(
        get: {
          viewModel.errorMessage != nil
        },
        // removes the error message when the alert closes
        set: { isPresented in
          if !isPresented {
            viewModel.errorMessage = nil
          }
        }
      )
    ) {
      Button("Aceptar", role: .cancel) {}
    } message: {
      Text(viewModel.errorMessage ?? "")
    }
    // G-09: "Verifica tu cuenta" with the email she just registered
    .fullScreenCover(isPresented: $showVerification) {
      NavigationStack {
        EmailVerificationPage(
          email: email,
          codeAlreadySent: true,
          onBack: {
            // The account already exists so going back returns to the login where she can verify later when she logs in
            showVerification = false
            dismiss()
          }
        )
      }
    }
  }
}

#Preview {
  RegistrationPage()
}
