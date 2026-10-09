//
//  SocialMediaCard.swift
//  ADAXIntegra
//
//  Created by Lakshmi Jara on 08/10/26.
//

import SwiftUI

// shows the social media links as horizontal logos
struct SocialMediaCard: View {
  let onFacebookTap: () -> Void
  let onInstagramTap: () -> Void
  let onXTap: () -> Void
  let onTikTokTap: () -> Void

  var body: some View {
    SurfaceCard(cornerRadius: 28) {
      VStack(alignment: .leading, spacing: 20) {
        Text(
          "Consulta nuestras redes sociales para conocer nuestras actividades y novedades."
        )
        .font(.subheadline)
        .foregroundColor(Color("PrimaryAdax"))

        HStack(spacing: 0) {
          socialButton(
            image: "FacebookLogo",
            name: "Facebook",
            action: onFacebookTap
          )

          socialButton(
            image: "InstagramLogo",
            name: "Instagram",
            action: onInstagramTap
          )

          socialButton(
            image: "XLogo",
            name: "X",
            action: onXTap
          )

          socialButton(
            image: "TikTokLogo",
            name: "TikTok",
            action: onTikTokTap
          )
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(20)
    }
  }

  private func socialButton(
    image: String,
    name: String,
    action: @escaping () -> Void
  ) -> some View {
    Button(action: action) {
      Image(image)
        .resizable()
        .scaledToFit()
        .frame(width: 32, height: 32)
        .frame(maxWidth: .infinity, minHeight: 44)
        .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
    .accessibilityLabel(name)
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    SocialMediaCard(
      onFacebookTap: {},
      onInstagramTap: {},
      onXTap: {},
      onTikTokTap: {}
    )
    .padding()
  }
}
