//
//  DocumentImageCard.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 16/09/26.
//

import SwiftUI

struct DocumentImageCard: View {
  let image: Image

  var body: some View {
    image
      .resizable()
      .scaledToFit()
      .padding(.horizontal, 24)
      .padding(.vertical, 16)
      .frame(maxWidth: .infinity)
      .frame(height: 280)
      .background(Color.white)
      .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
      .overlay(
        RoundedRectangle(cornerRadius: 28, style: .continuous)
          .stroke(Color("PrimaryAdax"), lineWidth: 3)
      )
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    DocumentImageCard(image: Image("placeholderImage"))
      .padding()
  }
}
