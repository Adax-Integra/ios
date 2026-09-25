//
//  SurfaceCard.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 21/09/26.
//

import SwiftUI

// Reusable rounded, white, soft-shadowed container used as the visual
// surface for text fields, dropdowns, document cards, etc
struct SurfaceCard<Content: View>: View {
  var cornerRadius: CGFloat = 16
  var borderColor: Color? = nil
  var borderWidth: CGFloat = 0
  var showsShadow: Bool = true

  @ViewBuilder let content: () -> Content

  var body: some View {
    let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)

    content()
      .background(shape.fill(Color.white))
      .clipShape(shape)
      .overlay(
        shape.stroke(
          borderColor ?? .clear,
          lineWidth: borderColor == nil ? 0 : borderWidth
        )
      )
      .shadow(
        color: showsShadow ? Color.black.opacity(0.07) : .clear,
        radius: showsShadow ? 6 : 0,
        x: 0,
        y: showsShadow ? 3 : 0
      )
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    VStack(spacing: 16) {
      SurfaceCard(showsShadow: true) {
        Text("Plain surface")
          .padding()
          .frame(maxWidth: .infinity, alignment: .leading)
      }

      SurfaceCard(cornerRadius: 28, borderColor: Color("PrimaryAdax"), borderWidth: 2) {
        Text("Bordered surface (document-card style)")
          .padding()
          .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
    .padding()
  }
}
