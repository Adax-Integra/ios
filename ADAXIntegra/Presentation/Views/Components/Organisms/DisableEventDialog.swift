//
//  DisableEventDialog.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 14/10/26.
//

import SwiftUI

// E-03: last confirmation before disabling an event
struct DisableEventDialog: View {
  let isLoading: Bool
  let onConfirm: () -> Void
  let onCancel: () -> Void

  var body: some View {
    VStack(spacing: 28) {
      VStack(spacing: 12) {
        Text("¿Deshabilitar este evento?")
          .font(.system(size: 22, weight: .bold))
          .multilineTextAlignment(.center)
          .foregroundColor(.primary)

        Text("El evento dejará de mostrarse en el calendario. Esta acción no se puede deshacer.")
          .font(.system(size: 14))
          .multilineTextAlignment(.center)
          .foregroundColor(.gray)
      }

      VStack(spacing: 12) {
        PrimaryButton(
          customHeight: 22,
          title: isLoading ? "Deshabilitando..." : "Sí, deshabilitar",
          isDisabled: isLoading,
          action: onConfirm
        )

        SecondaryButton(
          title: "Cancelar",
          isDisabled: isLoading,
          action: onCancel
        )
      }
    }
    .padding(.horizontal, 16)
    .padding(.top, 32)
    .padding(.bottom, 16)
    .background(Color.white)
    .cornerRadius(24)
    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 4)
    .padding(.horizontal, 32)
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
