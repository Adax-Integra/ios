//
//  CollaboratorInfoRow.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 17/10/26.
//

import SwiftUI

// Molecule with the label on the left and the value on the right
struct CollaboratorInfoRow: View {
  let label: String
  let value: String

  var body: some View {
    HStack(alignment: .firstTextBaseline, spacing: 12) {
      Text(label)
        .font(.system(size: 15))
        .foregroundColor(Color("InsideTextAndIcons"))

      Spacer(minLength: 8)

      Text(value)
        .font(.system(size: 14, weight: .regular))
        .foregroundColor(Color("OnBackground"))
        .multilineTextAlignment(.trailing)
    }
  }
}

#Preview {
  VStack(spacing: 12) {
    CollaboratorInfoRow(label: "Rol", value: "Interna / colaboradora")
    CollaboratorInfoRow(label: "Sede", value: "Querétaro, Qro.")
  }
  .padding()
  .background(Color("Background"))
}
