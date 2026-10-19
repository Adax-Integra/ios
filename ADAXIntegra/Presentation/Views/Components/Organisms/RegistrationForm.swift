//
//  RegistrationForm.swift
//  ADAXIntegra
//
//  Created by Lakshmi Jara on 22/09/26.
//
// G-01

import SwiftUI

// organism that groups and validates registration fields
struct RegistrationForm: View {

  // connects each field to the values saved in RegistrationPage
  @Binding var name: String
  @Binding var lastName: String
  @Binding var email: String
  @Binding var countryCode: String?
  @Binding var phoneNumber: String
  @Binding var password: String
  @Binding var confirmPassword: String

  // recives the phone codes provided by the template
  var countryCodes: [String]

  let action: () -> Void

  private var fullName: String {
    let firstName = name.trimmingCharacters(in: .whitespacesAndNewlines)
    let surname = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
    return "\(firstName) \(surname)"
  }

  // allows letters, accents, ñ, ü, and spaces
  private func isValidNameText(_ text: String) -> Bool {
    let pattern = #"^[\p{L}\p{M}]+(?: [\p{L}\p{M}]+)*$"#
    return text.range(of: pattern, options: .regularExpression) != nil
  }

  // validates names and the maximum length
  private var isNameValid: Bool {
    let firstName = name.trimmingCharacters(in: .whitespacesAndNewlines)
    let surname = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
    let fullName = "\(firstName) \(surname)"
    return isValidNameText(firstName)
      && isValidNameText(surname)
      && fullName.count <= 100
  }

  // validates email format without accents, ñ or emojis
  private var isEmailValid: Bool {
    let pattern = #"^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)+$"#
    return email.range(of: pattern, options: .regularExpression) != nil
  }

  // checks the password requirements
  private var isPasswordValid: Bool {
    password.count >= 8 && password.count <= 24
      && password.rangeOfCharacter(from: .uppercaseLetters) != nil
      && password.rangeOfCharacter(from: .decimalDigits) != nil
      && password.rangeOfCharacter(from: .punctuationCharacters.union(.symbols)) != nil
      && password.unicodeScalars.allSatisfy { $0.isASCII && $0.value >= 33 && $0.value <= 126 }
      && password.rangeOfCharacter(from: .lowercaseLetters) != nil
  }

  // enables registration if all fields contain valid data
  private var isFormValid: Bool {
    isNameValid && isEmailValid
      && countryCode != nil
      && phoneNumber.count == 10
      && phoneNumber.allSatisfy { $0.isASCII && $0.isNumber }
      && isPasswordValid
      && password == confirmPassword
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 18) {

      // name field
      VStack(alignment: .leading, spacing: 6) {
        LabeledTextField(
          title: "Nombre",
          placeholder: "Ingresa tu nombre",
          text: $name
        )

        if !name.isEmpty && !isValidNameText(name) {
            FieldErrorLabel("Solo se permiten letras, acentos y ñ.")
        }
      }

      // last name field
      VStack(alignment: .leading, spacing: 6) {
        LabeledTextField(
          title: "Apellido",
          placeholder: "Ingresa tu apellido",
          text: $lastName
        )

        if !lastName.isEmpty && !isValidNameText(lastName) {
            FieldErrorLabel("Solo se permiten letras, acentos y espacios.")
        }

        if fullName.count > 100 {
            FieldErrorLabel("El nombre completo debe tener máximo 100 caracteres.")
        }
      }

      // email field
      VStack(alignment: .leading, spacing: 6) {
        LabeledTextField(
          title: "Correo electrónico",
          placeholder: "correo@ejemplo.com",
          keyboardType: .emailAddress,
          text: $email
        )

        if !email.isEmpty && !isEmailValid {
            FieldErrorLabel("Ingresa un correo electrónico válido, sin acentos ni ñ.")
        }
      }

      // phone field
      VStack(alignment: .leading, spacing: 6) {
        PhoneField(
          countryCodes: countryCodes,
          countryCode: $countryCode,
          phone: $phoneNumber
        )

        if !phoneNumber.isEmpty
          && (phoneNumber.count != 10 || !phoneNumber.allSatisfy({ $0.isASCII && $0.isNumber }))
        {
            FieldErrorLabel("El teléfono debe contener 10 dígitos.")
        }
      }

      // password field
      VStack(alignment: .leading, spacing: 6) {
        PasswordTextField(
          title: "Contraseña",
          placeholder: "Ingresa tu contraseña",
          text: $password
        )

        Text(
          "Debe tener entre 8 y 24 caracteres, una mayúscula, una minúscula, un número y un carácter especial. No puede incluir acentos ni letras especiales."
        )
        .font(.caption)
        .foregroundStyle(.secondary)
        .fixedSize(horizontal: false, vertical: true)

        // shows missing password requirements
        if !password.isEmpty {
          if password.count < 8 || password.count > 24 {
              FieldErrorLabel("La contraseña debe tener entre 8 y 24 caracteres.")

          }

          if password.rangeOfCharacter(from: .uppercaseLetters) == nil {
              FieldErrorLabel("Falta una letra mayúscula.")
          }

          if password.rangeOfCharacter(from: .lowercaseLetters) == nil {
              FieldErrorLabel("Falta una letra minúscula.")
          }

          if password.rangeOfCharacter(from: .decimalDigits) == nil {
              FieldErrorLabel("Falta un número.")

          }

          if password.rangeOfCharacter(from: .punctuationCharacters.union(.symbols)) == nil {
              FieldErrorLabel("Falta un carácter especial.")

          }

          if !password.unicodeScalars.allSatisfy({ $0.isASCII && $0.value >= 33 && $0.value <= 126 }
          ) {
              FieldErrorLabel("No se permiten espacios, acentos, ñ ni emojis")

          }
        }
      }

      // confirm password field
        VStack(alignment: .leading, spacing: 6) {
            PasswordTextField(
                title: "Confirmar contraseña",
                placeholder: "Confirma tu contraseña",
                text: $confirmPassword
            )
            
            if !confirmPassword.isEmpty && password != confirmPassword {
                FieldErrorLabel("Las contraseñas no coinciden.")
            }
        }

      PrimaryButton(
        customWidth: .infinity,
        customHeight: 30,
        title: "Registrarse",
        isDisabled: !isFormValid
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
    countryCodes: ["+52", "+1"],
    action: { print("Formulario enviado") }
  )
  .padding()
}
