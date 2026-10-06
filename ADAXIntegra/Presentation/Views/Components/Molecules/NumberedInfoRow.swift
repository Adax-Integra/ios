//
//  NumberedInfoRow.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 02/10/26.
//

import SwiftUI

// Row with a numbered badge, a title and a short description
struct NumberedInfoRow: View {
  let number: Int
  let title: String
  let description: String

  var body: some View {
    HStack(alignment: .top, spacing: 16) {
      NumberBadge(number: number)

      VStack(alignment: .leading, spacing: 4) {
        Text(title)
          .font(.system(size: 16, weight: .semibold))
          .foregroundColor(Color("OnBackground"))

        Text(description)
          .font(.system(size: 13))
          .foregroundColor(Color("InsideTextAndIcons"))
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

#Preview {
  NumberedInfoRow(
    number: 1,
    title: "¿Qué datos recopilamos?",
    description:
      "La información que nos proporcionas al crear tu cuenta y durante el uso de la aplicación."
  )
  .padding()
}
