//
//  RegistrationForm.swift
//  ADAXIntegra
//
//  Created by Lakshmi Jara on 22/09/26.
//

import SwiftUI

// organism that groups and validates registration fields
struct RegistrationForm: View {

  @Binding var name: String
  @Binding var lastName: String
  @Binding var email: String
  @Binding var countryCode: String?
  @Binding var phoneNumber: String
  @Binding var password: String
  @Binding var confirmPassword: String

  let action: () -> Void
  var onBack: (() -> Void)? = nil

  // enables registration if all fields contain valid data
  private var isFormValid: Bool {
    !name.isEmpty && !lastName.isEmpty && !email.isEmpty && email.contains("@")
      && countryCode != nil && phoneNumber.count == 10
      && password.count >= 8 && password == confirmPassword
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 18) {
      Button(action: {
        onBack?()
      }) {
        Image(systemName: "chevron.left")
          .font(.system(size: 18, weight: .semibold))
          .foregroundColor(.primary)
      }
      .padding(.top, 8)

      VStack(alignment: .leading, spacing: 8) {
        Text("Crear cuenta")
          .font(.system(size: 24, weight: .bold))
          .foregroundColor(.primary)

        Text("Ingresa tus datos para registrarte")
          .font(.system(size: 14))
          .foregroundColor(.secondary)
      }
      .padding(.bottom, 8)

      LabeledTextField(
        title: "Nombre",
        placeholder: "Ingresa tu nombre",
        text: $name
      )

      LabeledTextField(
        title: "Apellido",
        placeholder: "Ingresa tu apellido",
        text: $lastName
      )

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
#Preview {
  @Previewable @State var name = ""
  @Previewable @State var lastName = ""
  @Previewable @State var email = ""
  @Previewable @State var countryCode: String? = "+52"
  @Previewable @State var phoneNumber = ""
  @Previewable @State var password = ""
  @Previewable @State var confirmPassword = ""

  RegistrationForm(
    name: $name,
    lastName: $lastName,
    email: $email,
    countryCode: $countryCode,
    phoneNumber: $phoneNumber,
    password: $password,
    confirmPassword: $confirmPassword,
    action: { print("Formulario enviado") }
  )
  .padding()
}
