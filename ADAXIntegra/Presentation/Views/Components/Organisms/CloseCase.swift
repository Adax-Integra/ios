//
//  CloseCase.swift
//
//  Created by Oscar Alexander Vilchis Soto on 01/10/26.
//
// Popup alert abpout closing a case for US v-11


import SwiftUI

struct CloseCase: View {
  let onConfirm: () -> Void
  let onCancel: () -> Void

  var body: some View {
    ConfirmDialogCard(
      title: "¿Deseas cerrar este caso?",
      message: "El caso dejará de mostrarse como abierto.",
      confirmTitle: "Cerrar",
      cancelTitle: "Cancelar",
      onConfirm: onConfirm,
      onCancel: onCancel
    )
  }
}

#Preview {
  ZStack {
    Color.black.opacity(0.4).ignoresSafeArea()

    CloseCase(
      onConfirm: { print("Confirmar tap") },
      onCancel: { print("Cancelar tap") }
    )
  }
}
