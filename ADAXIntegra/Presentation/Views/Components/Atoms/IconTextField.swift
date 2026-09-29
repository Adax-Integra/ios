//
//  IconTextField.swift
//  ADAXIntegra
//
//  Created by Laura Cintora on 22/09/26.
//

import SwiftUI

struct IconTextField: View {
  let title: String
  let placeholder: String
  let systemIcon: String
  var isSecure: Bool = false
  var keyboard: UIKeyboardType = .default
  @Binding var text: String
  @State private var isVisible: Bool = false
  private let iconGray = Color(red: 0.42, green: 0.45, blue: 0.50)  // #6B7380
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(title)
        .font(.system(size: 17))
        .foregroundColor(iconGray)
        .padding(.leading, 4)
      HStack(spacing: 16) {
        Image(systemName: systemIcon)
          .font(.system(size: 22, weight: .light))
          .foregroundColor(iconGray)
          .frame(width: 32)
        Group {
          if isSecure && !isVisible {
            SecureField(placeholder, text: $text)
          } else {
            TextField(placeholder, text: $text)
              .keyboardType(keyboard)
          }
        }
        .font(.system(size: 17))
        .foregroundColor(.black)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
        if isSecure {
          Button {
            isVisible.toggle()
          } label: {
            Image(systemName: isVisible ? "eye" : "eye.slash")
              .font(.system(size: 20))
              .foregroundColor(iconGray)
          }
          .buttonStyle(.plain)
        }
      }
      .padding(.horizontal, 18)
      .frame(height: 56)
      .background(Color.white)
      .cornerRadius(14)
      .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 3)
    }
  }
}
#Preview {
  VStack(spacing: 16) {
    IconTextField(
      title: "Correo electrónico",
      placeholder: "tu@correo.com",
      systemIcon: "envelope",
      text: .constant(""))
    IconTextField(
      title: "Contraseña",
      placeholder: "**************",
      systemIcon: "lock",
      isSecure: true,
      text: .constant(""))
  }
  .padding(24)
  .background(Color(red: 0.925, green: 0.925, blue: 0.925))
}
