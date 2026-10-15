//
//  AccountStatusBadge.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 10/10/26.
//

import SwiftUI

// Molecule that shows if an account is active or inactive.
// The text changes too, so it does not depend only on the color
struct AccountStatusBadge: View {
  let isActive: Bool

  private var color: Color {
    isActive ? Color("StatusCompleted") : Color("InsideTextAndIcons")
  }
  var body: some View {
    HStack(spacing: 6) {
      Circle()
        .fill(color)
        .frame(width: 6, height: 6)

      Text(isActive ? "Activa" : "Inactiva")
        .font(.system(size: 12, weight: .semibold))
        .foregroundColor(Color("OnBackground"))
    }
    .padding(.horizontal, 10)
    .padding(.vertical, 4)
    .background(Capsule().fill(color.opacity(0.15)))
  }
}

#Preview {
  HStack {
    AccountStatusBadge(isActive: true)
    AccountStatusBadge(isActive: false)
  }
  .padding()
}
