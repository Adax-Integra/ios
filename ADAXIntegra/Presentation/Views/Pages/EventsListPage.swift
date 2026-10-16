//
//  EventsListPage.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 15/10/26.
//

import SwiftUI

// Events list page that shows every active event, same for internal and external users
struct EventsListPage: View {
  @Environment(\.dismiss) private var dismiss
  // View model that manages the UI state and event data load
  @StateObject private var viewModel: EventsViewModel

  // Initializes the view with an optional view model dependency
  init(viewModel: EventsViewModel? = nil) {
    let model = viewModel ?? EventsViewModel(scope: .all)
    _viewModel = StateObject(wrappedValue: model)
  }

  var body: some View {
    ZStack {
      Color("Background").ignoresSafeArea()

      ScrollView {
        VStack(alignment: .leading, spacing: 16) {
          // Main navigation header with title and back button
          PageHeader(
            title: "Eventos",
            backAction: { dismiss() },
            subtitle: "Gestiona los eventos de la asociación"
          )

          content
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
      }
      // Enables refresh with sliding down
      .refreshable {
        await viewModel.loadEvents()
      }
    }
    .navigationBarBackButtonHidden(true)
    .toolbar(.hidden, for: .navigationBar)
    // Asynchronously loads events when the view appears
    .task {
      await viewModel.loadEvents()
    }
  }

  @ViewBuilder
  private var content: some View {
    if viewModel.isLoading && viewModel.events.isEmpty {
      // Displays loading indicator on initial fetch
      ProgressView()
        .frame(maxWidth: .infinity)
        .padding()
    } else if let error = viewModel.errorMessage, viewModel.events.isEmpty {
      // Displays error state along with a retry  button
      VStack(alignment: .leading, spacing: 8) {
        Text(error)
          .font(.subheadline)
          .foregroundStyle(.secondary)

        Button("Reintentar") {
          Task { await viewModel.loadEvents() }
        }
        .foregroundColor(Color("PrimaryAdax"))
      }
    } else if viewModel.events.isEmpty {
      Text("No hay eventos por ahora.")
        .font(.subheadline)
        .foregroundStyle(.secondary)
    } else {
      // Lazy vertical stack rendering the event cards efficiently.
      LazyVStack(spacing: 16) {
        ForEach(viewModel.events) { event in
          EventListCard(event: event)
        }
      }
    }
  }
}

// Preview with fake events to see if it works

private struct MockGetEventsUseCase: GetEventsUseCaseProtocol {
  func getEvents(scope: EventScope) async throws -> [EventListItem] {
    [
      EventListItem(
        id: "1", title: "Marcha por nuestros derechos",
        description: "Alza tu voz, no estás sola.",
        startsAt: "2026-10-25T18:00:00+00:00", endsAt: "2026-10-25T20:00:00+00:00",
        modality: "Presencial", location: "Plaza de la Constitución", imageUrl: nil),
      EventListItem(
        id: "2", title: "Círculo de apoyo entre mujeres",
        description: "Escucha, comparte, acompaña.",
        startsAt: "2026-11-12T17:00:00+00:00", endsAt: "2026-11-12T19:00:00+00:00",
        modality: "Presencial", location: "Sede Adax", imageUrl: nil),
    ]
  }
}

#Preview {
  NavigationStack {
    EventsListPage(
      viewModel: EventsViewModel(scope: .all, getEventsUseCase: MockGetEventsUseCase()))
  }
}
