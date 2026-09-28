//
//  FieldErrorLabel.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 22/09/26.
//

import SwiftUI

// Single-purpose caption used below form fields to surface a validation
// error
struct FieldErrorLabel: View {
  let message: String

  // Configurable typography
  var size: CGFloat = 13
  var weight: Font.Weight = .regular

  init(
    _ message: String,
    size: CGFloat = 13,
    weight: Font.Weight = .regular
  ) {
    self.message = message
    self.size = size
    self.weight = weight
  }

  var body: some View {
    Text(message)
      .font(.system(size: size, weight: weight))
      .foregroundColor(Color("Error"))
      .fixedSize(horizontal: false, vertical: true)
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    VStack(alignment: .leading, spacing: 12) {
      FieldErrorLabel("Debe tener 10 dígitos")
      FieldErrorLabel("Este campo es requerido", weight: .bold)
      FieldErrorLabel("Error crítico", size: 16, weight: .semibold)
    }
    .padding()
  }
}
