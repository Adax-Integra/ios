//
//  PrimaryButton.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 16/09/26.
//

import SwiftUI

struct PrimaryButton: View {
  let title: String
  let isDisabled: Bool
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      Text(title)
        .font(.headline)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding()
        .background(
          RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(Color("Primary"))
        )
    }
    .disabled(isDisabled)
    .opacity(isDisabled ? 0.6 : 1.0)
  }
}

#Preview {
  PrimaryButton(
    title: "Primary Button",
    isDisabled: false,
    action: {
      print("Button tapped")  // Just to confirm the button is being clicked
    }
  )
  .padding()
}
