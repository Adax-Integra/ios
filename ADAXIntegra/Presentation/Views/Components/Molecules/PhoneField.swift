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

  // Phone numbers are stored as strings, but the entry must be exactly 10 digits
  private let phoneLength = 10

  // When non-nil, a "FieldErrorLabel" is rendered below the row and the phone
  // "SurfaceCard" gets a red outline. The parent (or a helper like
  // "PhoneField.incompleteErrorMessage") decides when to display it
  var errorMessage: String? = nil

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

        SurfaceCard(
          borderColor: errorMessage != nil ? Color("Error") : nil,
          borderWidth: errorMessage != nil ? 1 : 0
        ) {
          TextInput(
            placeholder: placeholder,
            text: $phone,
            keyboardType: .phonePad,
            customHeight: customHeight,
            maxLength: phoneLength
          )
        }
      }

      if let errorMessage {
        FieldErrorLabel(errorMessage)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    // Strip any non-digit character (spaces, dashes, pasted "+", etc.) so the
    // stored value is always a raw 0-9 string capped at "phoneLength"
    .onChange(of: phone) { _, newValue in
      let digitsOnly = newValue.filter(\.isNumber)
      let clamped = String(digitsOnly.prefix(phoneLength))
      if clamped != newValue {
        phone = clamped
      }
    }
  }
}

extension PhoneField {
  // Convenience validator for callers that want the built-in 10-digit rule
  // Returns nil when the value is valid (empty or exactly 10 digits)
  static func validationError(for phone: String) -> String? {
    if phone.isEmpty { return nil }
    return phone.count == 10 ? nil : "Debe tener 10 dígitos"
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

      PhoneField(
        errorMessage: "Debe tener 10 dígitos",
        countryCode: .constant("+52"),
        phone: .constant("44612")
      )
    }
    .padding()
  }
}
