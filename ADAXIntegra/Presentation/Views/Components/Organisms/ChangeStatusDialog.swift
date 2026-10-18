//
//  ChangeStatusDialog.swift
//  ADAXIntegra
//
//  Created by Laura Cintora on 17/10/26.
//

import SwiftUI

// G-04: Shown before changing the status of a collaborator
struct ChangeStatusDialog: View {
  // Name shown in bold
  let collaboratorName: String
  // Current account status
  let isActive: Bool
  // True while the request is being sent
  let isLoading: Bool
  let onConfirm: () -> Void
  let onCancel: () -> Void

  // An active account will be turned off, and the other way around
  private var title: String {
    if isActive {
      return "¿Desactivar cuenta?"
    } else {
      return "¿Activar cuenta?"
    }
  }

  private var explanation: String {
    if isActive {
      return "Ya no podrá iniciar sesión."
    } else {
      return "Podrá volver a iniciar sesión."
    }
  }

  private var confirmTitle: String {
    if isLoading {
      return "Guardando..."
    } else {
      return "Confirmar"
    }
  }

  var body: some View {
    VStack(spacing: 24) {
      VStack(spacing: 14) {
        Image(systemName: "exclamationmark")
          .font(.system(size: 20, weight: .bold))
          .foregroundColor(.white)
          .frame(width: 44, height: 44)
          .background(Circle().fill(Color("PrimaryAdax")))

        Text(title)
          .font(.system(size: 20, weight: .bold))
          .foregroundColor(Color("OnBackground"))
      }

      VStack(spacing: 8) {
        Text(collaboratorName)
          .font(.system(size: 16, weight: .semibold))
          .foregroundColor(Color("OnBackground"))

        Text(explanation)
          .font(.system(size: 14))
          .foregroundColor(Color("InsideTextAndIcons"))
      }
      .multilineTextAlignment(.center)

      // Same confirm or cancel buttons used in the other dialogs of the app
      ConfirmationActions(
        prompt: "",
        onConfirm: onConfirm,
        onDismiss: onCancel,
        confirmTitle: confirmTitle,
        dismissTitle: "Cancelar",
        showsPrompt: false,
        isDisabled: isLoading
      )
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 28)
    .background(Color.white)
    .cornerRadius(28)
    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 4)
    .padding(.horizontal, 24)
  }
}

#Preview {
  ZStack {
    Color.black.opacity(0.4).ignoresSafeArea()

    VStack(spacing: 24) {
      ChangeStatusDialog(
        collaboratorName: "Braziña setesientossetentaysiete",
        isActive: true,
        isLoading: false,
        onConfirm: {},
        onCancel: {}
      )
      ChangeStatusDialog(
        collaboratorName: "Celine Hernández Alonso",
        isActive: false,
        isLoading: false,
        onConfirm: {},
        onCancel: {}
      )
    }
  }
}
