//
//  CollaboratorContactCard.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 17/10/26.
//

import SwiftUI

// Organism with the email and the phone of a collaborator, each one with a button to copy the info to the portapapeles
struct CollaboratorContactCard: View {
  let email: String
  let phoneText: String
  let canCopyPhone: Bool
  let onCopyEmail: () -> Void
  let onCopyPhone: () -> Void

  var body: some View {
    SurfaceCard {
      VStack(alignment: .leading, spacing: 14) {
        Text("Información de Contacto")
          .font(.system(size: 18, weight: .bold))
          .foregroundColor(Color("PrimaryAdax"))

        CopyableInfoRow(
          systemImage: "envelope", label: "Correo electrónico", value: email,
          onCopy: onCopyEmail)

        Divider()

        CopyableInfoRow(
          systemImage: "phone", label: "Número de teléfono", value: phoneText,
          canCopy: canCopyPhone, onCopy: onCopyPhone)
      }
      .padding(20)
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

#Preview {
  CollaboratorContactCard(
    email: "celine.hernandez@adax.org", phoneText: "+52 442 111 0000",
    canCopyPhone: true, onCopyEmail: {}, onCopyPhone: {}
  )
  .padding()
  .background(Color("Background"))
}
