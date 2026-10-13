//
//  PodcastCard.swift
//  ADAXIntegra
//
//  Created by Lakshmi Jara on 06/10/26.
//

import SwiftUI

// shows the podcast card on the external home screen
struct PodcastCard: View {
  let onTap: () -> Void

  var body: some View {
    Button(action: onTap) {
      SurfaceCard(cornerRadius: 28) {
        HStack(spacing: 16) {
          Image("SpotifyLogo")
            .resizable()
            .scaledToFit()
            .frame(width: 80, height: 80)

          VStack(alignment: .leading, spacing: 8) {
            Text("Las hadas sí existen")
              .font(.title3)
              .bold()
              .foregroundColor(Color("PrimaryAdax"))

            Text("Escucha nuestro podcast en Spotify.")
              .font(.subheadline)
              .foregroundColor(Color("SecondaryAdax"))
          }
          .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
      }
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    PodcastCard(onTap: {})
      .padding()
  }
}
