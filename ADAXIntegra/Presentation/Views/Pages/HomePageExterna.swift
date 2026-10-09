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
  @EnvironmentObject private var session: AuthSession
  @StateObject private var profileViewModel = ProfileViewModel()

  var body: some View {
    HomeTemplate {
      HomeHeader(onNotificationsTap: {
        // to do: connect the notification screen
      })
    } welcome: {
      VStack(alignment: .leading, spacing: 8) {
        Text(
          profileViewModel.profile.map { "¡Hola, \($0.name)!" }
            ?? "¡Hola!"
        )
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
          .frame(minHeight: 120, alignment: .topLeading)
          .padding(20)
      }
    } events: {
      // space reserved for the events carousel
      VStack(alignment: .leading, spacing: 12) {
        Text("Eventos")
          .font(.title2.bold())
          .foregroundColor(Color("OnBackground"))

        Color.clear
          .frame(height: 200)
      }
    } socialMedia: {
      VStack(alignment: .leading, spacing: 12) {
        Text("Redes sociales")
          .font(.title2.bold())
          .foregroundColor(Color("OnBackground"))

        SocialMediaCard(
          onFacebookTap: {
            openExternalLink(
              "https://www.facebook.com/ADAxDigitales/"
            )
          },
          onInstagramTap: {
            openExternalLink(
              "https://www.instagram.com/adax_digitales_a.c._/"
            )
          },
          onXTap: {
            openExternalLink("https://x.com/ADAxDigitalesAC")
          },
          onTikTokTap: {
            openExternalLink(
              "https://www.tiktok.com/@adax_digitales"
            )
          }
        )
      }
    } podcast: {
      VStack(alignment: .leading, spacing: 12) {
        Text("Podcast")
          .font(.title2.bold())
          .foregroundColor(Color("OnBackground"))

        PodcastCard(
          onSpotifyTap: {
            openExternalLink(
              "https://open.spotify.com/show/5yaZdYjbR36lrDmaJ0WhVk"
            )
          },
          onYouTubeTap: {
            openExternalLink("https://www.youtube.com/@AdaxDigitales")
          }
        )
      }
    }
    // loads the account name using the existing profile service
    .task(id: session.userId) {
      await profileViewModel.loadProfile(for: session.userId)
    }
  }

  // opens an external address using the system URL action
  private func openExternalLink(_ address: String) {
    guard let url = URL(string: address) else { return }
    openURL(url)
  }
}

#Preview {
  HomePageExterna()
    .environmentObject(AuthSession())
}
