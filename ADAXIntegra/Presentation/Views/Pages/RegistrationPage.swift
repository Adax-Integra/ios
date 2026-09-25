//
//  RegistrationPage.swift
//  ADAXIntegra
//
//  Created by Lakshmi Jara on 22/09/26.
//

import SwiftUI

// page that manages the registration form state and actions
struct RegistrationPage: View {
  @Environment(\.dismiss) private var dismiss
  @StateObject private var viewModel = RegistrationViewModel()

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

        Task {
          await viewModel.createAccount(
            name: name,
            lastName: lastName,
            email: email,
            countryCode: countryCode,
            phone: phoneNumber,
            password: password,
            confirmPassword: confirmPassword
          )
        }
      }
    )
  }
}

#Preview {
  RegistrationPage()
}
