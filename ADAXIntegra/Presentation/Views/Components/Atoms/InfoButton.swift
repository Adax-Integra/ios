//
//  InfoButton.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 16/09/26.
//

import SwiftUI

struct InfoButton: View {
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      Image(systemName: "info.circle")
        .font(.system(size: 20, weight: .regular))
        .foregroundColor(Color("InsideTextAndIcons"))
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
