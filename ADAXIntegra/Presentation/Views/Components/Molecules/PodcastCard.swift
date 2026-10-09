//
//  PodcastCard.swift
//  ADAXIntegra
//
//  Created by Lakshmi Jara on 06/10/26.
//

import SwiftUI

// shows the podcast and its available platforms
struct PodcastCard: View {
  let onSpotifyTap: () -> Void
  let onYouTubeTap: () -> Void

  var body: some View {
    SurfaceCard(cornerRadius: 28) {
      VStack(alignment: .leading, spacing: 16) {
        Text("Las hadas sí existen")
          .font(.title3.bold())
          .foregroundColor(Color("PrimaryAdax"))

        Text("Escucha o ve nuestro podcast.")
          .font(.subheadline)
          .foregroundColor(Color("SecondaryAdax"))

        Button(action: onSpotifyTap) {
          HStack(spacing: 12) {
            Image("SpotifyLogo")
              .resizable()
              .scaledToFit()
              .frame(width: 28, height: 28)
              .accessibilityHidden(true)

            Text("Escuchar en Spotify")
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.vertical, 8)
        }

        Button(action: onYouTubeTap) {
          HStack(spacing: 12) {
            Image("YouTubeLogo")
              .resizable()
              .scaledToFit()
              .frame(width: 28, height: 28)
              .accessibilityHidden(true)

            Text("Ver en YouTube")
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.vertical, 8)
        }
      }
      .font(.subheadline.bold())
      .foregroundColor(Color("PrimaryAdax"))
      .buttonStyle(.plain)
      .padding(20)
    }
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    PodcastCard(
      onSpotifyTap: {},
      onYouTubeTap: {}
    )
    .padding()
  }
}
