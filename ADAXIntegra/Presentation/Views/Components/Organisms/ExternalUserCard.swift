//
//  ExternalUserCard.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 16/10/26.
//

import SwiftUI

// G-16: one external account of the list.
// Inactive accounts look disabled because their details can not be opened
struct ExternalUserCard: View {
  let item: ExternalUserListItem
  // The "Activa" badge is only needed when the list mixes both states
  var showsStatus: Bool = false

  private var nameColor: Color {
    item.isActive ? Color("OnBackground") : Color("InsideTextAndIcons")
  }

  var body: some View {
    HStack(spacing: 14) {
      UserAvatar(initials: item.initials, size: 48)
        .opacity(item.isActive ? 1 : 0.4)

      VStack(alignment: .leading, spacing: 2) {
        Text(item.fullName)
          .font(.system(size: 16, weight: .semibold))
          .foregroundColor(nameColor)

        Label(item.email ?? "Sin correo", systemImage: "envelope")
          .font(.system(size: 13))
          .foregroundColor(Color("InsideTextAndIcons"))
          .lineLimit(1)
          .truncationMode(.tail)

        Label("Registro: \(item.createdDateText)", systemImage: "calendar")
          .font(.system(size: 13))
          .foregroundColor(Color("InsideTextAndIcons"))
      }

      Spacer(minLength: 8)

      if showsStatus || !item.isActive {
        AccountStatusBadge(isActive: item.isActive)
      }

      // Only active accounts have the arrow because only they open G-07
      if item.isActive {
        Chevron(direction: .right, size: 14, customColor: "InsideTextAndIcons")
      }
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
    ExternalUserCard(
      item: ExternalUserListItem(
        id: "1", name: "Ana", lastName: "López Ruiz", email: "ana.lopez@correo.com",
        createdAt: "2026-09-30T18:22:10Z", isActive: true))
    ExternalUserCard(
      item: ExternalUserListItem(
        id: "2", name: "Sofía", lastName: "Martínez", email: "sofia.mtz@correo.com",
        createdAt: "2026-08-12T10:05:00Z", isActive: false))
    ExternalUserCard(
      item: ExternalUserListItem(
        id: "3", name: "Lucía", lastName: "Gómez", email: "lucia.gomez@correo.com",
        createdAt: "2026-09-15T09:30:00Z", isActive: true),
      showsStatus: true)
  }
  .padding()
  .background(Color("Background"))
}
