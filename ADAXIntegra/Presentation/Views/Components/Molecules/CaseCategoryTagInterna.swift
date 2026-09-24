//
//  CaseCategoryTag.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 22/09/26.
//
import SwiftUI

struct CaseCategoryTag: View {
  var systemName: String = "square.grid.2x2"

  let category: String

  var body: some View {
    HStack(spacing: 6) {
      Icon(size: 14, systemName: systemName)

      Text(category)
        .font(.system(size: 12, weight: .medium))
        .foregroundColor(Color("InsideTextAndIcons"))
    }
    .padding(.horizontal, 10)
    .padding(.vertical, 6)
    .background(
      Capsule()
        .fill(Color("Background"))
    )
  }
}

#Preview {
  ZStack {
    Color.white.ignoresSafeArea()

    HStack(spacing: 8) {
      CaseCategoryTag(category: "Violencia Familiar")
      CaseCategoryTag(category: "Violencia Económica")
    }
    .padding()
  }
}
