//
//  ActivityLogCard.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 18/10/26.
//

import SwiftUI

// Molecule with the icon, action title and a sentence of what happened
struct ActivityLogCard: View {
  let iconName: String
  let title: String
  let description: String

  var body: some View {
    HStack(spacing: 12) {
      // Soft purple circle behind the icon
      ZStack {
        Circle()
          .fill(Color("PrimaryAdax").opacity(0.15))
          .frame(width: 44, height: 44)
        Image(systemName: iconName)
          .font(.system(size: 18, weight: .medium))
          .foregroundColor(Color("PrimaryAdax"))
      }

      VStack(alignment: .leading, spacing: 4) {
        Text(title)
          .font(.system(size: 16, weight: .bold))
          .foregroundColor(Color("OnBackground"))
          // Lets long texts grow in height instead of being cut
          .fixedSize(horizontal: false, vertical: true)

        Text(description)
          .font(.system(size: 14))
          .foregroundColor(Color("InsideTextAndIcons"))
          .fixedSize(horizontal: false, vertical: true)
      }

      Spacer(minLength: 0)
    }
    .padding(12)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(
      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .fill(Color("CardColor"))
        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
    )
  }
}

#Preview {
  ActivityLogCard(
    iconName: "person.crop.circle.badge.xmark",
    title: "Desactivación de colaboradora",
    description: "Administrador Adax desactivó la cuenta de Valeria Martinez"
  )
  .padding()
}
