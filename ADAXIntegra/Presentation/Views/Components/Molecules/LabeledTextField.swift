//
//  LabeledTextField.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 21/09/26.
//

import SwiftUI

// Molecule that composes a "FieldLabel" + "TextInput"
struct LabeledTextField: View {
  var title: String
  var placeholder: String
  var customWidth: CGFloat = .infinity
  var customHeight: CGFloat = 50
  var keyboardType: UIKeyboardType = .default

  @Binding var text: String

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      if !title.isEmpty {
        FieldLabel(title)
      }

      SurfaceCard {
        TextInput(
          placeholder: placeholder,
          text: $text,
          keyboardType: keyboardType,
          customWidth: customWidth,
          customHeight: customHeight
        )
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
    }
    .padding()
  }
}
