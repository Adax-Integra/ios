//
//  RegistrationForm.swift
//  ADAXIntegra
//
//  Created by Lakshmi Jara on 22/09/26.
//

import SwiftUI

struct RegistrationForm: View {
  @Binding var email: String
  @Binding var countryCode: String?
  @Binding var phoneNumber: String
  @Binding var password: String
  @Binding var confirmPassword: String

  let action: () -> Void

  private var isFormValid: Bool {
    !email.isEmpty && email.contains("@") && countryCode != nil && phoneNumber.count == 10
      && password.count >= 8 && password == confirmPassword
  }

  var body: some View {
    VStack(spacing: 18) {
      LabeledTextField(
        title: "Correo electrónico",
        placeholder: "correo@ejemplo.com",
        keyboardType: .emailAddress,
        text: $email
      )

      PhoneField(
        countryCode: $countryCode,
        phone: $phoneNumber
      )

      PasswordTextField(
        title: "Contraseña",
        placeholder: "Ingresa tu contraseña",
        text: $password
      )

      PasswordTextField(
        title: "Confirmar contraseña",
        placeholder: "Confirma tu contraseña",
        text: $confirmPassword
      )

      PrimaryButton(
        customWidth: .infinity,
        customHeight: 30,
        title: "Registrarse",
        isDisabled: !isFormValid,
      ) {
        action()
      }
      .padding(.top, 8)
    }
  }
}
