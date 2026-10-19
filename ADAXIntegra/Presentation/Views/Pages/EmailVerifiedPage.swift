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
    // Same success page as the rest of the confirmations
    SuccessPage(
      title: "¡Cuenta verificada!",
      message:
        "Tu correo quedó confirmado. Ya tienes acceso a la plataforma y una colaboradora de Adax revisará tu solicitud.",
      onContinue: onContinue
    )
  }
}

#Preview {
  EmailVerifiedPage(onContinue: {})
}
