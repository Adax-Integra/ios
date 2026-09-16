//
//  SecondaryButton.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 16/09/26.
//

import SwiftUI

struct SecondaryButton: View {
  let title: String
  let isDisabled: Bool
  let action: () -> Void

  private let primaryColor = Color(red: 99 / 255.0, green: 14 / 255.0, blue: 121 / 255.0)

  var body: some View {
    Button(action: action) {
      Text(title)
        .font(.headline)
        .foregroundColor(primaryColor)
        .frame(maxWidth: .infinity)
        .padding()
        .background(
          RoundedRectangle(cornerRadius: 12, style: .continuous)
            .stroke(primaryColor, lineWidth: 2)
        )
    }
    .disabled(isDisabled)
    .opacity(isDisabled ? 0.6 : 1.0)
  }
}

#Preview {
  SecondaryButton(
    title: "Secondary button",
    isDisabled: false,
    action: {
      print("Button tapped")  // Just to confirm the button is being clicked
    }
  )
  .padding()
}
