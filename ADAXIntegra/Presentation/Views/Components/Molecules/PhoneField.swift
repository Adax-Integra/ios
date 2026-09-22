//
//  PhoneField.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 22/09/26.
//

import SwiftUI

// Molecule that composes a "FieldLabel" + country-code "Dropdown" + phone "TextInput"
struct PhoneField: View {
  var title: String = "Teléfono celular"
  var placeholder: String = "Tu número aquí..."
  var countryCodePlaceholder: String = "+52"
  var countryCodes: [String] = ["+52", "+1"]

  var customHeight: CGFloat = 52
  var countryCodeWidth: CGFloat = 96
  var spacing: CGFloat = 12

  @Binding var countryCode: String?
  @Binding var phone: String

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      if !title.isEmpty {
        FieldLabel(title)
      }

      HStack(alignment: .top, spacing: spacing) {
        Dropdown(
          customWidth: countryCodeWidth,
          customHeight: customHeight,
          title: "",
          prompt: countryCodePlaceholder,
          options: countryCodes,
          selection: $countryCode
        )
        .frame(width: countryCodeWidth)

        LabeledTextField(
          title: "",
          placeholder: placeholder,
          customHeight: customHeight,
          keyboardType: .phonePad,
          text: $phone
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
      PhoneField(
        countryCode: .constant("+1"),
        phone: .constant("4461253367")
      )

      PhoneField(
        placeholder: "Tu número aquí...",
        countryCode: .constant(nil),
        phone: .constant("")
      )
    }
    .padding()
  }
}
