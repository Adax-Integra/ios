//
//  EventDisabledPage.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 14/10/26.
//

import SwiftUI

// E-03: shown after the backend confirms that the event was disabled
struct EventDisabledPage: View {
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

        Text("Evento deshabilitado")
          .font(.system(size: 26, weight: .bold))
          .foregroundColor(.primary)

        Text("El evento ya no aparece en el calendario.")
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

#Preview {
  EventDisabledPage(onFinish: { print("Finish tap") })
}
