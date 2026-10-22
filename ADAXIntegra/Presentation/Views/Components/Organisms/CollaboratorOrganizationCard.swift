//
//  CollaboratorOrganizationCard.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 17/10/26.
//

import SwiftUI

// Organism with the organization data of the internal user
struct CollaboratorOrganizationCard: View {
  let roleText: String
  let officeText: String
  let joinedAtText: String

  var body: some View {
    SurfaceCard {
      VStack(alignment: .leading, spacing: 14) {
        Text("Datos Organizacionales")
          .font(.system(size: 18, weight: .bold))
          .foregroundColor(Color("PrimaryAdax"))

        CollaboratorInfoRow(label: "Rol", value: roleText)
        Divider()
        CollaboratorInfoRow(label: "Sede", value: officeText)
        Divider()
        CollaboratorInfoRow(label: "Ingreso", value: joinedAtText)
      }
      .padding(20)
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

#Preview {
  CollaboratorOrganizationCard(
    roleText: "Interna / colaboradora", officeText: "Querétaro, Qro.",
    joinedAtText: "15 jul 2024"
  )
  .padding()
  .background(Color("Background"))
}
