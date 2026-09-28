//
//  InfoButton.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 16/09/26.
//

import SwiftUI

struct InfoButton: View {
  var size: CGFloat = 20
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      Image(systemName: "info.circle")
        .font(.system(size: size, weight: .regular))
        .foregroundColor(Color("InsideTextAndIcons"))
        .frame(width: max(44, size), height: max(44, size))
        .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  HStack {
    InfoButton(size: 16) {
      print("Info tapped")
    }
    InfoButton {
      print("Info tapped")
    }
    InfoButton(size: 32) {
      print("Info tapped")
    }
  }
}
