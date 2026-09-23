//
//  Chevron.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 21/09/26.
//

import SwiftUI

// Single SF Symbol chevron icon with customizable direction, size and color
struct Chevron: View {
  enum ChevronDirection {
    case up, right, down, left
  }

  var direction: ChevronDirection
  var size: CGFloat
  var customColor: String

  var rotation: Double {
    switch direction {
    case .up: return -90
    case .right: return 0
    case .down: return 90
    case .left: return 180
    }
  }

  var body: some View {
    Image(systemName: "chevron.right")
      .resizable()
      .scaledToFit()
      .rotationEffect(.degrees(rotation))
      .frame(width: size, height: size)
      .foregroundStyle(Color(customColor))
  }
}

#Preview {
  HStack(spacing: 20) {
    Chevron(direction: .up, size: 20, customColor: "PrimaryAdax")
    Chevron(direction: .down, size: 20, customColor: "InsideTextAndIcons")
  }
  .padding()
}
