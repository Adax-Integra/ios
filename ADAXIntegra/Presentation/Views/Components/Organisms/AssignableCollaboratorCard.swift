//
//  AssignableCollaboratorCard.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 17/10/26.
//

import SwiftUI

// Organism with one account that can be assigned to a case (R-10)
struct AssignableCollaboratorCard: View {
  let item: AssignableCollaborator
  let isSelected: Bool
  var isAssigned: Bool = false

  var body: some View {
    HStack(spacing: 14) {
      UserAvatar(initials: item.initials, size: 48)

      VStack(alignment: .leading, spacing: 2) {
        Text(item.fullName)
          .font(.system(size: 16, weight: .semibold))
          .foregroundColor(Color("OnBackground"))

        if isAssigned {
          Text("Ya asignada")
            .font(.system(size: 13))
            .foregroundColor(Color("InsideTextAndIcons"))
        }
      }

      Spacer(minLength: 8)

      Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
        .font(.system(size: 22))
        .foregroundColor(isSelected ? Color("PrimaryAdax") : Color("InsideTextAndIcons"))
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 14)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(
      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .fill(Color.white)
        .shadow(color: Color.black.opacity(0.07), radius: 6, x: 0, y: 3)
    )
    .overlay(
      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .stroke(Color("PrimaryAdax"), lineWidth: isSelected ? 2 : 0)
    )
  }
}

#Preview {
  VStack(spacing: 10) {
    AssignableCollaboratorCard(
      item: AssignableCollaborator(id: "1", name: "Ana", lastName: "López"),
      isSelected: true,
      isAssigned: true
    )
    AssignableCollaboratorCard(
      item: AssignableCollaborator(id: "2", name: "Mariana", lastName: "Ríos Pérez"),
      isSelected: false
    )
  }
  .padding()
  .background(Color("Background"))
}
