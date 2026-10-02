//
//  FloatingActionButton.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 30/09/26.
//

import SwiftUI

// Atom: circular button with an SF Symbol, meant to float over scrollable content
// (e.g. the "+" to create a new case)
struct FloatingActionButton: View {
  let systemName: String
  // Read by VoiceOver, since the button only shows an icon
  let accessibilityLabel: String
  var size: CGFloat = 56
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      Image(systemName: systemName)
        .font(.system(size: size * 0.45, weight: .semibold))
        .foregroundColor(.white)
        .frame(width: size, height: size)
        .background(Circle().fill(Color("PrimaryAdax")))
        .shadow(color: .black.opacity(0.25), radius: 6, y: 3)
    }
    .accessibilityLabel(accessibilityLabel)
  }
}

#Preview {
  FloatingActionButton(systemName: "plus", accessibilityLabel: "Nuevo caso") {}
    .padding()
}
