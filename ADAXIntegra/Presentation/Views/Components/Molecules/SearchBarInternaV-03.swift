//
//  SearchBar.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 23/09/26.
//

import SwiftUI

struct SearchBarInterna: View {
  var costumWidth: CGFloat = .infinity
  var fieldHeight: CGFloat = 50

  let placeholder: String
  @Binding var text: String

  var body: some View {
    HStack(spacing: 8) {
      Icon(systemName: "magnifyingglass")
        .font(.system(size: 22, weight: .semibold))
        .foregroundColor(Color("OnBackground"))

      TextInput(
        placeholder: placeholder,
        text: $text,
        customWidth: .infinity,
        customHeight: fieldHeight,
      )
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 6)
    .frame(maxWidth: costumWidth)
    .background(
      RoundedRectangle(cornerRadius: 24)
        .fill(Color.gray.opacity(0.3))
    )
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    SearchBarInterna(placeholder: "Buscar caso...", text: .constant("")).padding()
  }
}
