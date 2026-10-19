//
//  CollaboratorEditCard.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 19/10/26.
//

import SwiftUI

//Card with editable fields of a collaborator, shown in place of the contact card while editing
struct CollaboratorEditCard: View {
  @Binding var name: String
  @Binding var lastName: String
  @Binding var email: String
  @Binding var countryCode: String?
  @Binding var phone: String

  let countryCodes: [String]
  let nameError: String?
  let lastNameError: String?
  let emailError: String?
  let phoneError: String?

  var body: some View {
    SurfaceCard {
      VStack(alignment: .leading, spacing: 16) {
        Text("Editar información")
          .font(.system(size: 18, weight: .bold))
          .foregroundColor(Color("PrimaryAdax"))

        LabeledTextField(
          title: "Nombre(s)",
          placeholder: "Nombre(s)...",
          errorMessage: nameError,
          text: $name
        )

        LabeledTextField(
          title: "Apellidos",
          placeholder: "Apellidos...",
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
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()

        PhoneField(
          title: "Número de teléfono",
          countryCodes: countryCodes,
          errorMessage: phoneError,
          countryCode: $countryCode,
          phone: $phone
        )

        Text("Cada cambio queda registrado en la bitácora.")
          .font(.system(size: 13))
          .foregroundColor(Color("InsideTextAndIcons"))
      }
      .padding(20)
      .frame(maxWidth: .infinity, alignment: .leading)
      // for US G-11 when editing the text input cleans what is typed or pasted, line breaks and emojis never stay in the fields
      .onChange(of: name) { _, newValue in
        let filtered = EditFieldFilter.name(newValue)
        if filtered != newValue { name = filtered }
      }
      .onChange(of: lastName) { _, newValue in
        let filtered = EditFieldFilter.name(newValue)
        if filtered != newValue { lastName = filtered }
      }
      .onChange(of: email) { _, newValue in
        let filtered = EditFieldFilter.email(newValue)
        if filtered != newValue { email = filtered }
      }
    }
  }
}
// G-11: keeps out line breaks, emojis and other symbols the fields must not accept
private enum EditFieldFilter {
  static let maxNameLength = 50
  static let maxEmailLength = 128

  // Letters of any language (accents included), spaces, apostrophes, hyphens and dots
  static func name(_ value: String) -> String {
    let allowed = value.filter { character in
      character.isLetter || character == " " || character == "'" || character == "’"
        || character == "-" || character == "."
    }
    return String(allowed.prefix(maxNameLength))
  }

  static func email(_ value: String) -> String {
    let allowed = value.filter { $0.isASCII && !$0.isWhitespace && !$0.isNewline }
    return String(allowed.prefix(maxEmailLength))
  }
}

#Preview {
  ScrollView {
    CollaboratorEditCard(
      name: .constant("Celine"),
      lastName: .constant("Hernández"),
      email: .constant("celine.hernandez@adax.org"),
      countryCode: .constant("+52"),
      phone: .constant("4421110000"),
      countryCodes: ["+52", "+1"],
      nameError: nil,
      lastNameError: nil,
      emailError: nil,
      phoneError: nil
    )
    .padding()
  }
  .background(Color("Background"))
}
