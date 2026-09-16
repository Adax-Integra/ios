//
//  InfoButton.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 16/09/26.
//

import SwiftUI

struct InfoButton: View {
  let action: () -> Void

  private let iconColor = Color(red: 33 / 255.0, green: 37 / 255.0, blue: 41 / 255.0)

  var body: some View {
    Button(action: action) {
      Image(systemName: "info.circle")
        .font(.system(size: 20, weight: .regular))
        .foregroundColor(iconColor)
        .frame(width: 44, height: 44)
        .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  InfoButton(
    action: {
      print("Info tapped")
    }
  )
}
