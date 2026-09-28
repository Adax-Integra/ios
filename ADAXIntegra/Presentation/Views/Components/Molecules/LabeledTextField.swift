//
//  LabeledTextField.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 21/09/26.
//

import SwiftUI

// Molecule that composes a "FieldLabel" + "TextInput" (+ optional "FieldErrorLabel")
struct LabeledTextField: View {
  var title: String
  var placeholder: String
  var customWidth: CGFloat = .infinity
  var customHeight: CGFloat = 50
  var keyboardType: UIKeyboardType = .default

  // Optional hard cap on characters. Forwarded to the underlying "TextInput"
  // so pasted/typed content beyond the limit is trimmed automatically
  var maxLength: Int? = nil

  // When non-nil, a "FieldErrorLabel" is rendered below the field and the
  // "SurfaceCard" gets a red outline
  var errorMessage: String? = nil

  @Binding var text: String

  private var isInError: Bool { errorMessage != nil }

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      if !title.isEmpty {
        FieldLabel(title)
      }

      SurfaceCard(
        borderColor: isInError ? Color("Error") : nil,
        borderWidth: isInError ? 1 : 0
      ) {
        TextInput(
          placeholder: placeholder,
          text: $text,
          keyboardType: keyboardType,
          customWidth: customWidth,
          customHeight: customHeight,
          maxLength: maxLength
        )
      }

      if let errorMessage {
        FieldErrorLabel(errorMessage)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    VStack(spacing: 16) {
      LabeledTextField(
        title: "Describe tu caso",
        placeholder: "Describe tu caso aquí...",
        customHeight: 150,
        text: .constant("")
      )

      LabeledTextField(
        title: "Municipio",
        placeholder: "Tu texto aquí...",
        text: .constant("")
      )

      LabeledTextField(
        title: "RFC",
        placeholder: "Ingresa tu RFC...",
        maxLength: 13,
        errorMessage: "Debe tener 13 caracteres",
        text: .constant("ABC")
      )
    }
    .padding()
  }
}
