//
//  CopyableInfoRow.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 17/10/26.
//

import SwiftUI

// Molecule that shows an icon, a label, a value and a copy button
struct CopyableInfoRow: View {
  let systemImage: String
  let label: String
  let value: String
  // Hidden when there is nothing real to copy 
  var canCopy: Bool = true
  let onCopy: () -> Void

  var body: some View {
    HStack(spacing: 14) {
      Image(systemName: systemImage)
        .font(.system(size: 14))
        .foregroundColor(Color("PrimaryAdax"))
        .frame(width: 44, height: 44)
        .background(Circle().fill(Color("PrimaryAdax").opacity(0.12)))

      VStack(alignment: .leading, spacing: 2) {
        Text(label)
          .font(.system(size: 14))
          .foregroundColor(Color("InsideTextAndIcons"))

        Text(value)
          .font(.system(size: 14, weight: .medium))
          .foregroundColor(Color("OnBackground"))
          .lineLimit(1)
          .minimumScaleFactor(0.8)
      }

      Spacer(minLength: 8)

      if canCopy {
        Button("Copiar", action: onCopy)
          .font(.system(size: 14, weight: .bold))
          .foregroundColor(Color("PrimaryAdax"))
      }
    }
  }
}

#Preview {
  VStack(spacing: 12) {
    CopyableInfoRow(
      systemImage: "envelope", label: "Correo electrónico",
      value: "celine.hernandez@adax.org", onCopy: {})
    CopyableInfoRow(
      systemImage: "phone", label: "Número de teléfono",
      value: "Sin teléfono", canCopy: false, onCopy: {})
  }
  .padding()
  .background(Color("Background"))
}
