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
    isActive ? "¿Desactivar cuenta?" : "¿Activar cuenta?"
  }

  private var explanation: String {
    isActive ? "Ya no podrá iniciar sesión." : "Podrá volver a iniciar sesión."
  }

  private var confirmTitle: String {
    isLoading ? "Guardando..." : "Confirmar"
  }

  var body: some View {
    ConfirmDialogCard(
      title: title,
      highlight: collaboratorName,
      message: explanation,
      confirmTitle: confirmTitle,
      cancelTitle: "Cancelar",
      isConfirmDisabled: isLoading,
      onConfirm: onConfirm,
      onCancel: onCancel
    )
  }
}

#Preview {
  ZStack {
    Color.black.opacity(0.4).ignoresSafeArea()

    VStack(spacing: 24) {
      ChangeStatusDialog(
        collaboratorName: "Celine Hernández Alonso",
        isActive: true,
        isLoading: false,
        onConfirm: {},
        onCancel: {}
      )
    }
  }
}
