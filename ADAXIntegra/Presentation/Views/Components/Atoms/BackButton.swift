//
//  BackButton.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 16/09/26.
//

import SwiftUI

struct BackButton: View {
  let action: () -> Void

  private let primaryColor = Color(red: 99 / 255.0, green: 14 / 255.0, blue: 121 / 255.0)

  var body: some View {
    Button(action: action) {
      Image(systemName: "chevron.left")
        .font(.system(size: 25, weight: .semibold))
        .foregroundColor(primaryColor)
        .frame(width: 44, height: 44)
        .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  BackButton(
    action: {
      print("Back tapped")
    }
  )
}
