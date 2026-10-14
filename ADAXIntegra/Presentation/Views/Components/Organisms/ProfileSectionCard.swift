//
//  ProfileSectionCard.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 06/10/26.
//

import SwiftUI

// Organism that groups the rows of one section of the external user's data.
// "isLocked" marks the sections the admin cannot edit
struct ProfileSectionCard<Content: View>: View {
  let title: String
  var isLocked: Bool = false
  @ViewBuilder var content: () -> Content

  var body: some View {
    SurfaceCard {
      VStack(alignment: .leading, spacing: 14) {
        HStack {
          Text(title)
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(Color("OnBackground"))

          Spacer()

          if isLocked {
            Label("No editable", systemImage: "lock")
              .font(.system(size: 12))
              .foregroundColor(Color("InsideTextAndIcons"))
          }
        }

        content()
      }
      .padding(20)
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

#Preview {
  ProfileSectionCard(title: "Datos de registro", isLocked: true) {
    InfoRow(label: "Nombre(s)", value: "Sandra")
    InfoRow(label: "Apellidos", value: "Pérez Ruiz")
  }
  .padding()
  .background(Color("Background"))
}
