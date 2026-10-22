//
//  CollaboratorCard.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 10/10/26.
//

import SwiftUI

// Organism with the data of one collaborator in the G-06 list
struct CollaboratorCard: View {
  let item: CollaboratorListItem

  var body: some View {
    HStack(spacing: 14) {
      UserAvatar(initials: item.initials, size: 48)

      VStack(alignment: .leading, spacing: 2) {
        Text(item.fullName)
          .font(.system(size: 16, weight: .semibold))
          .foregroundColor(Color("OnBackground"))

        Label(item.email ?? "Sin correo", systemImage: "envelope")
          .font(.system(size: 13))
          .foregroundColor(Color("InsideTextAndIcons"))
          .lineLimit(1)
          .truncationMode(.tail)
      }

      Spacer(minLength: 8)

      AccountStatusBadge(isActive: item.isActive)
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 14)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(
      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .fill(Color.white)
        .shadow(color: Color.black.opacity(0.07), radius: 6, x: 0, y: 3)
    )
  }
}

#Preview {
  VStack(spacing: 10) {
    CollaboratorCard(
      item: CollaboratorListItem(
        id: "1", name: "Lucía", lastName: "Gómez Ruiz", email: "lucia.gomez@adax.com",
        role: "internal", isActive: true))
    CollaboratorCard(
      item: CollaboratorListItem(
        id: "2", name: "Mariana", lastName: "Ríos Pérez", email: "mariana.rios@adax.com",
        role: "internal", isActive: true))
  }
  .padding()
  .background(Color("Background"))
}
