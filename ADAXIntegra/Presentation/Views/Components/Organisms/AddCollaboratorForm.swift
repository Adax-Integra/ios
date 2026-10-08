//
//  AddCollaboratorForm.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 01/10/26.
//

import SwiftUI

struct AddCollaboratorForm: View {
  @Binding var firstName: String
  @Binding var lastName: String
  @Binding var email: String
  @Binding var password: String
  @Binding var confirmPassword: String
  @Binding var countryCode: String?
  @Binding var phone: String

  var nameError: String? = nil
  var lastNameError: String? = nil
  var emailError: String? = nil
  var passwordError: String? = nil
  var confirmPasswordError: String? = nil
  var phoneError: String? = nil

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      LabeledTextField(
        title: "Nombre(s)",
        placeholder: "Escribe el nombre...",
        maxLength: 50,
        errorMessage: nameError,
        text: $firstName
      )

      LabeledTextField(
        title: "Apellido(s)",
        placeholder: "Escribe el/los apellido(s)",
        maxLength: 50,
        errorMessage: lastNameError,
        text: $lastName
      )

      LabeledTextField(
        title: "Correo electrónico",
        placeholder: "correo@ejemplo.com",
        keyboardType: .emailAddress,
        errorMessage: emailError,
        text: $email
      )

      PhoneField(
        errorMessage: phoneError,
        countryCode: $countryCode,
        phone: $phone
      )

      // Same password requierments text
      VStack(alignment: .leading, spacing: 6) {
        PasswordTextField(
          title: "Contraseña",
          placeholder: "Ingresa la contraseña",
          text: $password
        )

        Text(
          "Debe tener entre 8 y 24 caracteres, una mayúscula, una minúscula, un número y un carácter especial. No puede incluir acentos ni letras especiales."
        )

        .font(.caption)
        .foregroundStyle(.secondary)
        .fixedSize(horizontal: false, vertical: true)

        if let passwordError {
          FieldErrorLabel(passwordError)
        }
      }

      // Confirmation of the password

      VStack(alignment: .leading, spacing: 6) {
        PasswordTextField(
          title: "Confirmar contraseña",
          placeholder: "Confirma la contraseña",
          text: $confirmPassword
        )

        if let confirmPasswordError {
          FieldErrorLabel(confirmPasswordError)
        }
      }
    }
  }
}

#Preview {
  @Previewable @State var countryCode: String? = "+52"

  ScrollView {
    AddCollaboratorForm(
      firstName: .constant(""),
      lastName: .constant(""),
      email: .constant("correo-invalido"),
      password: .constant("abc"),
      confirmPassword: .constant("abcd"),
      countryCode: $countryCode,
      phone: .constant(""),
      emailError: "Ingresa un correo válido.",
      passwordError: "La contraseña no cumple con los requisitos.",
      confirmPasswordError: "Las contraseñas no coinciden."
    )
    .padding(20)
  }
  .background(Color("Background"))
}
