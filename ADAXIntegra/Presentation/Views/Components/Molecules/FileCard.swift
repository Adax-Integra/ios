//
//  FileCard.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 22/09/26.
//

import SwiftUI

// Molecule that composes a "FieldLabel" (+ optional "InfoButton") with a
// "DocumentImageCard".
struct FileCard: View {
  let title: String
  let image: Image

  var height: CGFloat = 280
  var cornerRadius: CGFloat = 28
  var infoAction: (() -> Void)? = nil

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack(spacing: 6) {
        FieldLabel(title)

        if let infoAction {
          InfoButton(size: 16, action: infoAction)
            // Collapse the InfoButton's 44pt HIG tap target down to the
            // label's height so this row is the same size with or without
            // an info button. The tap area itself stays 44pt.
            .padding(.vertical, -12)
            .padding(.horizontal, -12)
        }

        Spacer()
      }

      DocumentImageCard(
        image: image,
        height: height,
        cornerRadius: cornerRadius
      )
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    VStack(spacing: 20) {
      FileCard(
        title: "Comprobante de domicilio",
        image: Image("placeholderImage")
      )

      FileCard(
        title: "Identificación oficial",
        image: Image("placeholderImage"),
        infoAction: { print("Info tapped") }
      )
    }
    .padding()
  }
}
