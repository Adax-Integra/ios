//
//  CollaboratorProfileCard.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 17/10/26.
//

import SwiftUI

// Organism with the avatar but really are the initials of the internal user the name, the role, the date when they joined the app and the status
struct CollaboratorProfileCard: View {
  let initials: String
  let fullName: String
  let roleText: String
  let memberSinceText: String
  let isActive: Bool

  var body: some View {
    SurfaceCard {
      HStack(spacing: 16) {
        UserAvatar(initials: initials, size: 72)

        VStack(alignment: .leading, spacing: 8) {
          Text(fullName)
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(Color("OnBackground"))
            .lineLimit(2)
            .minimumScaleFactor(0.8)

          ViewThatFits(in: .horizontal) {
            HStack(spacing: 8) {
              rolePill
              memberSince
            }
            VStack(alignment: .leading, spacing: 4) {
              rolePill
              memberSince
            }
          }

          AccountStatusBadge(isActive: isActive)
        }

        Spacer(minLength: 0)
      }
      .padding(20)
    }
  }

  private var rolePill: some View {
    Text(roleText)
      .font(.system(size: 13, weight: .semibold))
      .foregroundColor(Color("OnBackground"))
      .padding(.horizontal, 10)
      .padding(.vertical, 4)
      .background(Capsule().fill(Color("PrimaryAdax").opacity(0.15)))
  }

  private var memberSince: some View {
    Text(memberSinceText)
      .font(.system(size: 13))
      .foregroundColor(Color("InsideTextAndIcons"))
  }
}

#Preview {
  CollaboratorProfileCard(
    initials: "CH", fullName: "Celine Hernández Alonso",
    roleText: "Interna / colaboradora", memberSinceText: "Desde jul 2024", isActive: false
  )
  .padding()
  .background(Color("Background"))
}
