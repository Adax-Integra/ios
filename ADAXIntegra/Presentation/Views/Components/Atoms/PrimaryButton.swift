// xcode: set sdk=iOS

//
//  PrimaryButton.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 16/09/26.
//

import SwiftUI

struct PrimaryButton: View {
  var customWidth: CGFloat = .infinity
  var customHeight: CGFloat = 30

  let title: String
  let isDisabled: Bool
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      Text(title)
        .font(.headline)
        .foregroundColor(.white)
        .frame(maxWidth: customWidth, maxHeight: customHeight)
        .padding()
        .background(
          RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(Color("PrimaryAdax"))
        )
    }
    .disabled(isDisabled)
    .opacity(isDisabled ? 0.6 : 1.0)
  }
}

#Preview {
  PrimaryButton(
    customWidth: .infinity,
    customHeight: 30,
    title: "Primary Button",
    isDisabled: false,
    action: {
      print("Button tapped")  // Just to confirm the button is being clicked
    }
  )
  .padding()
}
