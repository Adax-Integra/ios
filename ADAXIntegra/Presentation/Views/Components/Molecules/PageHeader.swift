//
//  PageHeader.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 22/09/26.
//

import SwiftUI

// Molecule that composes a "BackButton" with a large page title.
// Used as the top-of-screen header (e.g. "Verificar información").
struct PageHeader: View {
  let title: String
  let backAction: () -> Void

  var titleSize: CGFloat = 28
  var backButtonSize: CGFloat = 25
  // Horizontal margin between the "BackButton" and the title
  var titleSpacing: CGFloat = 4

  var body: some View {
    HStack(spacing: titleSpacing) {
      BackButton(size: backButtonSize, action: backAction)

      Text(title)
        .font(.system(size: titleSize, weight: .bold))
        .foregroundColor(Color("OnBackground"))
        .lineLimit(1)
        .minimumScaleFactor(0.7)

      Spacer(minLength: 0)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    VStack(alignment: .leading, spacing: 24) {
      PageHeader(title: "Verificar información") {
        print("Back tapped")
      }

      PageHeader(
        title: "Título con margen negativo",
        backAction: { print("Back tapped") },
        titleSpacing: -8
      )

      PageHeader(
        title: "Título con margen amplio",
        backAction: { print("Back tapped") },
        titleSpacing: 16
      )
    }
    .padding()
  }
}
