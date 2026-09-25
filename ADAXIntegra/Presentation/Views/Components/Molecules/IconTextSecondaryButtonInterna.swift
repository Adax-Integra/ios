//
//  IconTextSecondaryButton.swift
//  ADAXIntegra
//
//  Created by Nicolás Bravo Miguel on 22/09/26.
//

import SwiftUI

struct IconTextSecondaryButton: View {
  var customWidth: CGFloat = .infinity
  var customHeight: CGFloat = .infinity

  let systemName: String
  let title: String
  let isDisabled: Bool
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      HStack(spacing: 8) {
        Icon(color: Color("PrimaryAdax"), systemName: systemName)

        Text(title)
          .font(.headline)
          .foregroundColor(Color("PrimaryAdax"))
      }
      .frame(maxWidth: customWidth)
      .padding()
      .background(
        RoundedRectangle(cornerRadius: 12, style: .continuous)
          .stroke(Color("PrimaryAdax"), lineWidth: 2)
      )
    }
    .disabled(isDisabled)
    .opacity(isDisabled ? 0.6 : 1.0)
  }
}

#Preview {
  IconTextSecondaryButton(
    systemName: "line.3.horizontal.decrease",
    title: "Filtrar",
    isDisabled: false,
    action: {
      print("Filtrar tapped")  // Just to confirm the button is being clicked
    }
  )
  .padding()
}
