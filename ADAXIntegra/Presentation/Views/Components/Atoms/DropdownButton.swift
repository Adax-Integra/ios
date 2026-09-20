//
//  DropdownButton.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 18/09/26.
//

import SwiftUI

struct DropdownButton: View {
  var action: () -> Void

  var body: some View {
    Button(action: action) {
      Image(systemName: "chevron.down")
        .font(.system(size: 20, weight: .semibold))
        .foregroundColor(Color("InsideTextAndIcons"))
        .frame(width: 44, height: 44)
        .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  DropdownButton(
    action: {
      print("Action")
    }
  )
}
