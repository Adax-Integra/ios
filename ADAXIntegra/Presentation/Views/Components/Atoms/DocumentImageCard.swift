//
//  DocumentImageCard.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 16/09/26.
//

import SwiftUI

struct DocumentImageCard: View {
  let image: Image

  private let primaryColor = Color(red: 99 / 255.0, green: 14 / 255.0, blue: 121 / 255.0)

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
          .stroke(primaryColor, lineWidth: 3)
      )
  }
}

#Preview {
  ZStack {
    Color(UIColor.systemGray6).ignoresSafeArea()

    DocumentImageCard(image: Image("placeholderImage"))
      .padding()
  }
}
