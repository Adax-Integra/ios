//
//  CounterBadge.swift
//  ADAXIntegra
//
//  Created by Nicolás Bravo Miguel on 21/09/26.
//

import SwiftUI

struct CounterBadge: View {
  let count: Int
  let label: String

  var body: some View {
    HStack(spacing: 4) {
      Text("\(count)")
        .font(.system(size: 13, weight: .bold))

      Text(label)
        .font(.system(size: 13, weight: .medium))
    }
    .foregroundColor(.white)
    .padding(.horizontal, 14)
    .padding(.vertical, 8)
    .background(
      Capsule()
        .fill(Color("PrimaryAdax"))
    )
  }
}

#Preview {
  CounterBadge(count: 12, label: "Casos totales")
    .padding()
}
