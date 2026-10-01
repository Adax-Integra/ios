//
//  IconTextPrimaryButton.swift
//  ADAXIntegra
//
//  Created by Nicolás Bravo Miguel on 22/09/26.
//

import SwiftUI

struct IconTextPrimaryButton: View {
  var customWidth: CGFloat = .infinity
  var customHeight: CGFloat = 30

  let systemName: String
  let title: String
  let isDisabled: Bool
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      HStack(spacing: 8) {
        Icon(color: .white, systemName: systemName)

        Text(title)
          .font(.headline)
          .foregroundColor(.white)
      }
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
  IconTextPrimaryButton(
    systemName: "line.3.horizontal.decrease",
    title: "Filtrar",
    isDisabled: false,
    action: {
      print("Filtrar tapped")  // Just to confirm the button is being clicked
    }
  )
  .padding()
}
