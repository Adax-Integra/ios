//
//  DocumentImageCard.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 16/09/26.
//
//  Promoted from `Atoms/DocumentImageCard`. It's a molecule because it
//  composes an `Image` atom with the `SurfaceCard` atom (bordered variant).
//

import SwiftUI

struct DocumentImageCard: View {
  let image: Image
  var height: CGFloat = 280
  var cornerRadius: CGFloat = 28

  var body: some View {
    SurfaceCard(
      cornerRadius: cornerRadius,
      borderColor: Color("PrimaryAdax"),
      borderWidth: 3,
      showsShadow: false
    ) {
      image
        .resizable()
        .scaledToFit()
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .frame(height: height)
    }
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    DocumentImageCard(image: Image("placeholderImage"))
      .padding()
  }
}
