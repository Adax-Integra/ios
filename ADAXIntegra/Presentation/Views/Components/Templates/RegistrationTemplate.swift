//
//  RegistrationTemplate.swift
//  ADAXIntegra
//
//  Created by Lakshmi Jara on 22/09/26.
//

import SwiftUI

// template that defines the layout of the registration screen
struct RegistrationTemplate: View {

  @Binding var name: String
  @Binding var lastName: String
  @Binding var email: String
  @Binding var countryCode: String?
  @Binding var phoneNumber: String
  @Binding var password: String
  @Binding var confirmPassword: String

  let backAction: () -> Void
  let registerAction: () -> Void

  var body: some View {
    ZStack {
      Color("Background")
        .ignoresSafeArea()

      ScrollView {
        VStack(alignment: .leading, spacing: 24) {
          BackButton(action: backAction)

          Text("Crear cuenta")
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(Color("OnBackground"))

          Text("Ingresa tus datos para registrarte")
            .font(.system(size: 16, weight: .regular))
            .foregroundColor(Color("InsideTextAndIcons"))

          RegistrationForm(
            name: $name,
            lastName: $lastName,
            email: $email,
            countryCode: $countryCode,
            phoneNumber: $phoneNumber,
            password: $password,
            confirmPassword: $confirmPassword,
            action: registerAction
          )
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
      }
    }
  }
}
