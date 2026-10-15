//
//  EmailVerifiedPage.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 14/10/26.
//

import SwiftUI

struct EmailVerifiedPage: View {
  let onContinue: () -> Void

  var body: some View {
    ZStack {
      Color("Background").ignoresSafeArea()

      VStack(spacing: 20) {
        Spacer()

        Image(systemName: "checkmark")
          .font(.system(size: 40, weight: .bold))
          .foregroundColor(.white)
          .frame(width: 88, height: 88)
          .background(Circle().fill(Color("PrimaryAdax")))
          .accessibilityHidden(true)

        Text("Cuenta verificada")
          .font(.system(size: 26, weight: .bold))
          .foregroundColor(Color("OnBackgroundColor"))

        Text(
          "Tu correo quedó confirmado. Ya tienes acceso a la plataforma y una colaboradora de Adax revisará tu solicitud."
        )
        .font(.system(size: 15))
        .foregroundColor(Color("IconColor"))
        .multilineTextAlignment(.center)
        .fixedSize(horizontal: false, vertical: true)

        Spacer()

        SecondaryButton(title: "Continuar", isDisabled: false, action: onContinue)
          .padding(.bottom, 24)
      }
      .padding(.horizontal, 32)
    }
    .navigationBarBackButtonHidden(true)
  }
}

#Preview {
  EmailVerifiedPage(onContinue: {})
}
