//
//  ConfirmationPrompt.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 22/09/26.
//

import SwiftUI

// Single-purpose bold, purple, centered prompt used above a confirmation
// action (e.g. "¿Esta información esta correcta y actualizada?")
struct ConfirmationPrompt: View {
  let text: String
  var size: CGFloat
  var alignment: TextAlignment = .center

  init(
    _ text: String,
    size: CGFloat = 16,
    alignment: TextAlignment = .center
  ) {
    self.text = text
    self.size = size
    self.alignment = alignment
  }

  var body: some View {
    Text(text)
      .font(.system(size: size, weight: .bold))
      .foregroundColor(Color("PrimaryAdax"))
      .multilineTextAlignment(alignment)
      .frame(maxWidth: .infinity)
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    VStack(spacing: 20) {
      ConfirmationPrompt("¿Esta información esta correcta y actualizada?")

      ConfirmationPrompt(
        "¿Deseas continuar con el proceso?",
        size: 18
      )

      ConfirmationPrompt(
        "Confirma tu decisión antes de continuar",
        alignment: .leading
      )
    }
    .padding()
  }
}
