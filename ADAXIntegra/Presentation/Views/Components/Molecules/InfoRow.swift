//
//  InfoRow.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 06/10/26.
//

import SwiftUI

// Molecule that shows a read-only value with its label (e.g. "Colonia" / "Centro"
struct InfoRow: View {
  let label: String
  let value: String

  var body: some View {
    VStack(alignment: .leading, spacing: 2) {
      Text(label.uppercased())
        .font(.system(size: 16, weight: .regular))
        .foregroundColor(Color("InsideTextAndIcons"))

      Text(value)
        .font(.system(size: 16, weight: .regular))
        .foregroundColor(Color("OnBackground"))
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

#Preview {
  VStack(spacing: 14) {
    InfoRow(label: "Colonia", value: "Centro")
    InfoRow(label: "Código Postal", value: "76000")
  }
  .padding()
  .background(Color("Background"))
}
