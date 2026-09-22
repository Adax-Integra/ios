//
//  ConfirmationActions.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 22/09/26.
//

import SwiftUI

// Molecule that composes a "ConfirmationPrompt" with a pair of confirm /
// dismiss buttons
struct ConfirmationActions: View {
  let prompt: String
  let onConfirm: () -> Void
  let onDismiss: () -> Void

  var confirmTitle: String = "Sí"
  var dismissTitle: String = "No"

  var isDisabled: Bool = false
  var spacing: CGFloat = 12
  var buttonHeight: CGFloat = 56

  var body: some View {
    VStack(spacing: 16) {
      ConfirmationPrompt(prompt)

      HStack(spacing: spacing) {
        PrimaryButton(
          title: confirmTitle,
          isDisabled: isDisabled,
          action: onConfirm
        )
        .frame(maxWidth: .infinity, minHeight: buttonHeight, maxHeight: buttonHeight)

        SecondaryButton(
          title: dismissTitle,
          isDisabled: isDisabled,
          action: onDismiss
        )
        .frame(maxWidth: .infinity, minHeight: buttonHeight, maxHeight: buttonHeight)
      }
    }
    .frame(maxWidth: .infinity)
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    VStack(spacing: 32) {
      ConfirmationActions(
        prompt: "¿Esta información esta correcta y actualizada?",
        onConfirm: { print("Sí") },
        onDismiss: { print("No") }
      )

      ConfirmationActions(
        prompt: "¿Deseas continuar con el proceso?",
        onConfirm: { print("Continuar") },
        onDismiss: { print("Cancelar") },
        confirmTitle: "Continuar",
        dismissTitle: "Cancelar"
      )
    }
    .padding()
  }
}
