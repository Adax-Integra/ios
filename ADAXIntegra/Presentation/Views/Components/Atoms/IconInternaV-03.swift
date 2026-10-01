//
//  Icon.swift
//  ADAXIntegra
//
//  Created by Nicolás Bravo Miguel on 22/09/26.
//

import SwiftUI

struct Icon: View {
  var size: CGFloat = 20
  var color: Color = Color("InsideTextAndIcons")

  let systemName: String

  var body: some View {
    Image(systemName: systemName)
      .font(.system(size: size, weight: .regular))
      .foregroundColor(color)
  }
}

#Preview {
  HStack(spacing: 16) {
    Icon(systemName: "magnifyingglass")
    Icon(systemName: "line.3.horizontal.decrease")
    Icon(systemName: "exclamationmark.triangle")
    Icon(systemName: "exclamationmark.circle")
  }
  .padding()
}
