//
//  HomePageExterna.swift
//  ADAXIntegra
//
//  Created by Lakshmi Jara on 06/10/26.
//

import SwiftUI

// NV-01: home screen for external users

struct HomePageExterna: View {
  @Environment(\.openURL) private var openURL

  private let podcastURL = URL(
    string:
      "https://open.spotify.com/show/5yaZdYjbR36lrDmaJ0WhVk"
  )

  var body: some View {
    HomeTemplate {
      HomeHeader(onNotificationsTap: {
        // to do: connect the notification screen
      })
    } welcome: {
      VStack(alignment: .leading, spacing: 8) {
        Text("¡Hola!")
          .font(.largeTitle.bold())
          .foregroundColor(Color("OnBackground"))

        Text("No estás sola, estamos aquí para acompañarte")
          .font(.subheadline)
          .foregroundColor(Color("PrimaryAdax"))
      }
    } caseProgress: {
      // space reserved for the case progress component
      SurfaceCard(cornerRadius: 28) {
        Text("Tu caso en curso")
          .font(.headline)
          .foregroundColor(Color("OnBackground"))
          .frame(maxWidth: .infinity, alignment: .topLeading)
          .frame(minWidth: 120, alignment: .topLeading)
          .padding(20)
      }
    } events: {
      // space reserved for the events carrousel
      VStack(alignment: .leading, spacing: 12) {
        Text("Eventos")
          .font(.title2.bold())
          .foregroundColor(Color("OnBackground"))

        Color.clear
          .frame(height: 200)
      }
    } podcast: {
      VStack(alignment: .leading, spacing: 12) {
        Text("Podcast")
          .font(.title2.bold())
          .foregroundColor(Color("OnBackground"))

        PodcastCard(onTap: {
          guard let podcastURL else { return }
          openURL(podcastURL)
        })
      }
    }
  }
}

#Preview {
  HomePageExterna()
}
