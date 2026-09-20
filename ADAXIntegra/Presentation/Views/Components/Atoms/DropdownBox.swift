//
//  DropdownBox.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 19/09/26.
//

import SwiftUI

struct DropdownBox: View {
  let placeholder: String
  var text: String = ""

  var body: some View {
    Text(text.isEmpty ? placeholder : text)
      .font(.system(size: 16, weight: .regular))
      .foregroundColor(
        text.isEmpty
          ? Color("InsideTextAndIcons").opacity(0.6)
          : Color("OnBackground")
      )
      .lineLimit(1)
      .padding(.horizontal, 18)
      .frame(maxWidth: .infinity, minHeight: 52, alignment: .leading)
      .background(
        RoundedRectangle(cornerRadius: 16, style: .continuous)
          .fill(Color.white)
          .shadow(color: Color.black.opacity(0.07), radius: 6, x: 0, y: 3)
      )
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    DropdownBox(placeholder: "Selecciona una opción...")
      .padding()
  }
}
