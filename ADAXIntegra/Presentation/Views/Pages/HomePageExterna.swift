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
  @StateObject private var eventsViewModel = EventsViewModel(scope: .month)
  @StateObject private var casesViewModel: CasesViewModel
  @State private var isLoadingCases = true
  @State private var showUpload = false
  @State private var showNewCase = false

  init(userId: String) {
    _casesViewModel = StateObject(
      wrappedValue: CasesViewModel(
        repository: RemoteCaseRepository(),
        userId: userId
      )
    )
  }

  var body: some View {
    HomeTemplate {
      HomeHeader()
    } welcome: {
      VStack(alignment: .leading, spacing: 12) {
        Text(
          profileViewModel.profile.map { "¡Hola, \($0.name)!" }
            ?? "¡Hola!"
        )
        .font(.largeTitle.bold())
        .foregroundColor(Color("OnBackground"))

        Text("No estás sola, estamos aquí para acompañarte")
          .font(.subheadline)
          .foregroundColor(Color("PrimaryAdax"))
        if let profile = profileViewModel.profile,
          profile.verification != .verificado
        {
          VerificationBanner(status: profile.verification) {
            showUpload = true
          }
          .padding(.top, 4)
        }
      }
    } caseProgress: {
      if isLoadingCases {
        SurfaceCard(cornerRadius: 28) {
          ProgressView("Cargando casos...")
            .padding(20)
        }
      } else if casesViewModel.errorMessage != nil {
        SurfaceCard(cornerRadius: 28) {
          Text("No se pudo cargar la información de tus casos.")
            .padding(20)
        }
      } else if let latestCase = casesViewModel.latestCase {
        HomeCaseProgressCard(caseId: latestCase.id)
      } else {
        SurfaceCard(cornerRadius: 28) {
          VStack(alignment: .leading, spacing: 12) {
            Text("Tu caso en curso")
              .font(.title2.bold())

            Text("Todavía no tienes un caso en curso")
              .font(.subheadline)
              .foregroundColor(.secondary)

            Button {
              showNewCase = true
            } label: {
              Text("+ Nuevo caso")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color("PrimaryAdax"))
                .cornerRadius(16)
            }
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(20)
        }
      }
    } events: {
      EventsCarousel(viewModel: eventsViewModel)
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
    .task {
      await eventsViewModel.loadEvents()
    }
    // loads the user's cases
    .task {
      await casesViewModel.loadCases()
      isLoadingCases = false
    }
    .navigationDestination(isPresented: $showUpload) {
      IdentityDocumentsPage(userId: session.userId)
    }
    .navigationDestination(isPresented: $showNewCase) {
      if let userId = session.userId {
        CasesPage(
          viewModel: CasesViewModel(
            repository: RemoteCaseRepository(),
            userId: userId
          ),
          userId: userId,
          openNewCaseOnAppear: true
        )
      }
    }
    .onChange(of: showUpload) { _, isShowing in
      if !isShowing {
        Task {
          await profileViewModel.loadProfile(for: session.userId)
        }
      }
    }
    .onChange(of: showNewCase) { _, isShowing in
      if !isShowing {
        Task {
          await casesViewModel.loadCases()
        }
      }
    }
  }

  // opens an external address using the system URL action
  private func openExternalLink(_ address: String) {
    guard let url = URL(string: address) else { return }
    openURL(url)
  }
}

#Preview {
  NavigationStack {
    HomePageExterna(userId: "preview-user")
  }
  .environmentObject(AuthSession())
}
