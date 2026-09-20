//
//  Dropdown.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 19/09/26.
//

import SwiftUI

struct Dropdown: View {
  let placeholder: String
  var text: String = ""
  var action: () -> Void

  var body: some View {
    ZStack(alignment: .trailing) {
      DropdownBox(
        placeholder: placeholder,
        text: text,
        trailingInset: 58
      )
      .onTapGesture(perform: action)

      DropdownButton(action: action)
        .padding(.trailing, 6)
    }
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    Dropdown(
      placeholder: "Selecciona una opción...",
      action: {
        print("Dropdown tapped")
      }
    )
    .padding()
  }
}
