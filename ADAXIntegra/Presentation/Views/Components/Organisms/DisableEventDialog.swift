//
//  DisableEventDialog.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 14/10/26.
//

import SwiftUI
     
struct DisableEventDialog: View {
  let isLoading: Bool
  let onConfirm: () -> Void
  let onCancel: () -> Void

  var body: some View {
    ConfirmDialogCard(
      title: "¿Deshabilitar este evento?",
      message:
        "El evento dejará de mostrarse en el calendario. Esta acción no se puede deshacer.",
      confirmTitle: isLoading ? "Deshabilitando..." : "Deshabilitar",
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

    DisableEventDialog(
      isLoading: false,
      onConfirm: { print("Confirm tap") },
      onCancel: { print("Cancel tap") }
    )
  }
}
