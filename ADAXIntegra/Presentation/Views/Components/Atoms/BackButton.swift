//
//  BackButton.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 16/09/26.
//

import SwiftUI

struct BackButton: View {
  var size: CGFloat = 25
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      Image(systemName: "chevron.left")
        .font(.system(size: size, weight: .semibold))
        .foregroundColor(Color("PrimaryAdax"))
        .frame(width: max(44, size), height: max(44, size))
        .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  HStack {
    BackButton(size: 16) {
      print("Back tapped")
    }
    BackButton {
      print("Back tapped")
    }
    BackButton(size: 32) {
      print("Back tapped")
    }
  }
}
