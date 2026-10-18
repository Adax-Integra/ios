//
//  CollaboratorStatusCard.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 17/10/26.
//

import SwiftUI

// Organism that explains the account status active / inactive
struct CollaboratorStatusCard: View {
  let isActive: Bool
  let description: String

  private var color: Color {
    isActive ? Color("StatusCompleted") : Color("InsideTextAndIcons")
  }

  var body: some View {
    SurfaceCard {
      VStack(alignment: .leading, spacing: 10) {
        Text("Estatus En La Organización")
          .font(.system(size: 18, weight: .bold))
          .foregroundColor(Color("PrimaryAdax"))

        HStack(spacing: 8) {
          StatusDot(color: color)

          Text(isActive ? "Activa" : "Inactiva")
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(Color("OnBackground"))
        }

        Text(description)
          .font(.system(size: 14))
          .foregroundColor(Color("InsideTextAndIcons"))
      }
      .padding(20)
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

#Preview {
  VStack(spacing: 12) {
    CollaboratorStatusCard(
      isActive: true, description: "Puede iniciar sesión y recibir nuevas asignaciones.")
    CollaboratorStatusCard(
      isActive: false,
      description:
        "No puede iniciar sesión ni recibir nuevas asignaciones. Sus casos actuales permanecen en el expediente hasta que se reasignen."
    )
  }
  .padding()
  .background(Color("Background"))
}
