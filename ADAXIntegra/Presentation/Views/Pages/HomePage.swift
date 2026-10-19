//
//  HomePage.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 22/09/26.
//

import SwiftUI

// NV-04: home screen for internal users and administrators
struct HomePage: View {
  @Environment(\.openURL) private var openURL
  @EnvironmentObject private var session: AuthSession
  @StateObject private var profileViewModel = ProfileViewModel()
  @StateObject private var viewModel = HomeViewModel()
  @StateObject private var eventsViewModel = EventsViewModel(scope: .month)

  var body: some View {
    InternalHomeTemplate {
      HomeHeader()
    } welcome: {
      Text(
        profileViewModel.profile.map {
          "¡Hola, \($0.name)!"
        } ?? "¡Hola!"
      )
      .font(.largeTitle.bold())
      .foregroundColor(Color("OnBackground"))
    } records: {
      recordsSection
    } events: {
      eventsSection
    } podcast: {
      podcastSection
    }
    .task(id: session.userId) {
      await viewModel.loadRecords()
      await profileViewModel.loadProfile(for: session.userId)
    }
    .task {
      await eventsViewModel.loadEvents()
    }
    .refreshable {
      await viewModel.loadRecords()
      await eventsViewModel.loadEvents()

    }
  }

  private var recordsSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        Text("Expedientes recientes")
          .font(.title2.bold())
          .foregroundColor(Color("OnBackground"))

        Spacer()

        NavigationLink {
          ExpedientesListPage()
        } label: {
          Text("Ver todos")
            .font(.subheadline)
            .foregroundColor(Color("PrimaryAdax"))
        }
      }

      if viewModel.isLoading && viewModel.records.isEmpty {
        ProgressView()
          .frame(maxWidth: .infinity)
          .padding()
      } else if let error = viewModel.errorMessage {
        VStack(alignment: .leading, spacing: 8) {
          Text(error)
            .font(.subheadline)
            .foregroundStyle(.secondary)

          Button("Reintentar") {
            Task {
              await viewModel.loadRecords()
            }
          }
          .foregroundColor(Color("PrimaryAdax"))
        }
      } else if viewModel.records.isEmpty {
        Text("No hay expedientes con fecha de actualización.")
          .font(.subheadline)
          .foregroundStyle(.secondary)
      } else {
        ForEach(viewModel.records) { item in
          NavigationLink {
            RecordDetailPage(
              externalID: item.userId,
              externalName: item.name,
              recordId: item.id,
              initialStatus: RecordStatus(rawValue: item.status ?? "") ?? .sinEmpezar
            )
          } label: {
            RecordCardInterna(item: item)
          }
          .buttonStyle(.plain)
        }
      }
    }
  }

  private var eventsSection: some View {
    EventsCarousel(viewModel: eventsViewModel) {
      NavigationLink {
        CreateEventPage()
      } label: {
        Text("Agregar evento")
          .font(.subheadline)
          .foregroundColor(Color("PrimaryAdax"))
      }
    }
  }

  private var podcastSection: some View {
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
          openExternalLink(
            "https://www.youtube.com/@AdaxDigitales"
          )
        }
      )
    }
  }

  private func openExternalLink(_ address: String) {
    guard let url = URL(string: address) else { return }
    openURL(url)
  }
}

#Preview {
  NavigationStack {
    HomePage()
  }
  .environmentObject(AuthSession())
}
