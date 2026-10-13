//
//  FormTextField.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 01/10/26.
//

import SwiftUI

struct FormTextField: View {
  let label: String
  var placeholder: String = ""
  var isSecure: Bool = false
  var keyboard: UIKeyboardType = .default
  var errorMessage: String? = nil
  @Binding var text: String

  @State private var isVisible = false

  private var autocapitalization: TextInputAutocapitalization {
    (isSecure || keyboard == .emailAddress) ? .never : .words
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text(label.uppercased())
        .font(.caption)
        .fontWeight(.semibold)
        .foregroundColor(.secondary)
        .padding(.leading, 4)

      HStack {
        Group {
          if isSecure && !isVisible {
            SecureField(placeholder, text: $text)
          } else {
            TextField(placeholder, text: $text)
              .keyboardType(keyboard)
          }
        }
        .font(.body)
        .foregroundColor(.black)
        .textInputAutocapitalization(autocapitalization)
        .autocorrectionDisabled()

        if isSecure {
          Button {
            isVisible.toggle()
          } label: {
            Image(systemName: isVisible ? "eye" : "eye.slash")
              .foregroundColor(.gray)
          }
          .buttonStyle(.plain)
        }
      }

      .padding(.horizontal, 16)
      .frame(height: 52)
      .background(Color(red: 0.94, green: 0.93, blue: 0.98))
      .cornerRadius(12)
      .overlay(
        RoundedRectangle(cornerRadius: 12)
          .stroke(
            errorMessage == nil ? Color.gray.opacity(0.25) : Color("Error"),
            lineWidth: errorMessage == nil ? 1 : 1.5
          )
      )

      if let errorMessage {
        Text(errorMessage)
          .font(.caption)
          .foregroundColor(Color("Error"))
          .padding(.leading, 4)
      }
    }
  }
}

#Preview {
  VStack(spacing: 16) {
    FormTextField(label: "Nombre(s)", text: .constant(""))
    FormTextField(label: "Email", keyboard: .emailAddress, text: .constant(""))
    FormTextField(label: "Contraseña", isSecure: true, text: .constant(""))
    FormTextField(
      label: "Teléfono", placeholder: "10 dígitos", errorMessage: "Tiene que tener 10 dígitos",
      text: .constant("")
    )
  }
  .padding()
  .background(Color("Background"))
}
