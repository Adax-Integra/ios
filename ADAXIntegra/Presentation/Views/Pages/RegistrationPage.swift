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

  var body: some View {
    RegistrationTemplate(
      name: $name,
      lastName: $lastName,
      email: $email,
      countryCode: $countryCode,
      phoneNumber: $phoneNumber,
      password: $password,
      confirmPassword: $confirmPassword,
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
          // returns to login after the account is created successfully
          if viewModel.accountCreated {
            dismiss()
          }
        }
      }
    )
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
  }
}

#Preview {
  RegistrationPage()
}
