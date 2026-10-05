//
//  Checkbox.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 02/10/26.
//

import SwiftUI

// Square checkbox that flips a boolean value when tapped
struct Checkbox: View {
  @Binding var isChecked: Bool
  var size: CGFloat = 24

  var body: some View {
    Button {
      isChecked.toggle()
    } label: {
      Image(systemName: isChecked ? "checkmark.square.fill" : "square")
        .font(.system(size: size))
        .foregroundColor(Color(isChecked ? "PrimaryAdax" : "InsideTextAndIcons"))
        .frame(width: 44, height: 44)
        .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  HStack {
    Checkbox(isChecked: .constant(false))
    Checkbox(isChecked: .constant(true))
  }
}
