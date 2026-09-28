//
//  Badge.swift
//  ADAXIntegra
//
//  Created by Nicolás Bravo Miguel on 21/09/26.
//

import SwiftUI

struct Badge: View {
  enum Variant {
    case alta
    case media
    case baja
    case sinEvaluar

    var color: Color {
      switch self {
      case .alta:
        return Color("UrgencyHigh")
      case .media:
        return Color("UrgencyMedium")
      case .baja:
        return Color("UrgencyLow")
      case .sinEvaluar:
        return Color("InsideTextAndIcons")
      }
    }
  }

  let label: String
  let variant: Variant

  var body: some View {
    Text(label)
      .font(.system(size: 13, weight: .semibold))
      .foregroundColor(.white)
      .padding(.horizontal, 12)
      .padding(.vertical, 6)
      .background(
        Capsule()
          .fill(variant.color)
      )
  }
}

#Preview {
  HStack {
    Badge(label: "Alta", variant: .alta)
    Badge(label: "Media", variant: .media)
    Badge(label: "Baja", variant: .baja)
    Badge(label: "Sin evaluar", variant: .sinEvaluar)
  }
  .padding()
}
