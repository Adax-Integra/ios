//
//  FieldLabel.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 21/09/26.
//

import SwiftUI

// Single-purpose caption used above form fields (e.g. "Nombre completo").
struct FieldLabel: View {
  let title: String

  init(_ title: String) {
    self.title = title
  }

  var body: some View {
    Text(title)
      .font(.system(size: 16, weight: .regular))
      .foregroundColor(Color("OnBackground"))
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()
    VStack(alignment: .leading, spacing: 12) {
      FieldLabel("Nombre completo")
      FieldLabel("Teléfono celular")
      FieldLabel("País")
    }
    .padding()
  }
}
