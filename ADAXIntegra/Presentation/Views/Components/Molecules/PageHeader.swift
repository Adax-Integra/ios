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
  //Optional text shown below title
  var subtitle: String? = nil

  var body: some View {
    HStack(spacing: titleSpacing) {
      BackButton(size: backButtonSize, action: backAction)
      VStack(alignment: .leading, spacing: 2) {

        Text(title)
          .font(.system(size: titleSize, weight: .bold))
          .foregroundColor(Color("OnBackground"))
          .lineLimit(1)
          .minimumScaleFactor(0.7)

        if let subtitle {
          Text(subtitle)
            .font(.subheadline)
            .foregroundColor(Color("OnBackground").opacity(0.7))
        }
      }

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

      PageHeader(
        title: "Gestion de Colaboradoras", backAction: { print("Back tapped") },
        subtitle: "Administrar las cuentas de las colaboradoras"
      )
    }
    .padding()
  }
}
