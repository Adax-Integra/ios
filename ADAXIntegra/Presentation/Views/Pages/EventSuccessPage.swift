//
//  EventSuccessPage.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 14/10/26.
//

import SwiftUI

// E-02 and E-03: shown after the backend confirms that the event was updated or disabled
struct EventSuccessPage: View {
  let title: String
  let message: String
  let onFinish: () -> Void

  var body: some View {
    ZStack {
      Color("Background").ignoresSafeArea()

      VStack(spacing: 20) {
        ZStack {
          Circle()
            .fill(Color("PrimaryAdax"))
            .frame(width: 84, height: 84)

          Image(systemName: "checkmark")
            .font(.system(size: 38, weight: .bold))
            .foregroundColor(.white)
        }

        Text(title)
          .font(.system(size: 26, weight: .bold))
          .foregroundColor(.primary)

        Text(message)
          .font(.system(size: 15))
          .multilineTextAlignment(.center)
          .foregroundColor(.gray)

        PrimaryButton(
          customWidth: 180,
          customHeight: 22,
          title: "Entendido",
          isDisabled: false,
          action: onFinish
        )
        .padding(.top, 40)
      }
      .padding(.horizontal, 40)
    }
  }
}

#Preview("Deshabilitado") {
  EventSuccessPage(
    title: "Evento deshabilitado",
    message: "El evento ya no aparece en el calendario.",
    onFinish: {}
  )
}

#Preview("Actualizado") {
  EventSuccessPage(
    title: "Evento actualizado",
    message: "Los cambios ya aparecen en el calendario.",
    onFinish: {}
  )
}
