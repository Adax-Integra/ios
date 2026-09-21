//
//  PhoneField.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 21/09/26.
//

import SwiftUI

struct PhoneField: View {
  var title: String = "Teléfono celular"
  var countryCodeWidth: CGFloat = 110
  var fieldHeight: CGFloat = 50

  let countryCodes: [String]
  let countryCodePrompt: String

  @Binding var countryCode: String?
  @Binding var number: String

  var body: some View {
    VStack(alignment: .leading) {
      if !title.isEmpty {
        Text(title)
          .font(.system(size: 16, weight: .regular))
          .foregroundColor(Color("OnBackground"))
      }

      HStack(alignment: .top, spacing: 12) {
        Dropdown(
          customWidth: countryCodeWidth,
          customHeight: fieldHeight,
          title: "",
          prompt: countryCodePrompt,
          options: countryCodes,
          selection: $countryCode
        )
        .frame(width: countryCodeWidth)

        CustomTextField(
          customWidth: .infinity,
          minHeight: fieldHeight,
          maxHeight: fieldHeight,
          title: "",
          placeholder: "Tu texto aquí...",
          text: $number,
          keyboardType: .phonePad
        )
      }
    }
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    PhoneField(
      countryCodes: ["+52", "+1"],
      countryCodePrompt: "+52",
      countryCode: .constant("+52"),
      number: .constant("4461253367")
    )
    .padding()
  }
}
