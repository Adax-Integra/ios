//
//  EventsCarousel.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 15/10/26.
//

import SwiftUI

// Events section of the homes: title row + a 200 pt area.
// The title  open sthe full events list (same page for every role).
// `trailing` is an optional slot at the right of the title (the internal home
// puts its "Agregar evento" link there).
struct EventsCarousel<Trailing: View>: View {
  @ObservedObject var viewModel: EventsViewModel
  private let trailing: () -> Trailing

  // Height the homes already reserved for the carousel
  private let areaHeight: CGFloat = 200
  // Same horizontal padding as HomeTemplate / InternalHomeTemplate
  private let screenPadding: CGFloat = 20

  init(
    viewModel: EventsViewModel,
    @ViewBuilder trailing: @escaping () -> Trailing
  ) {
    _viewModel = ObservedObject(wrappedValue: viewModel)
    self.trailing = trailing
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        NavigationLink {
          EventsListPage()
        } label: {
          HStack(spacing: 6) {
            Text("Eventos")
              .font(.title2.bold())
            Image(systemName: "chevron.right")
              .font(.subheadline.weight(.semibold))
          }
          .foregroundColor(Color("OnBackground"))
        }
        .buttonStyle(.plain)

        Spacer()

        trailing()
      }

      content
        .frame(height: areaHeight, alignment: .top)
    }
  }

  @ViewBuilder
  private var content: some View {
    if viewModel.isLoading && viewModel.events.isEmpty {
      ProgressView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    } else if let error = viewModel.errorMessage, viewModel.events.isEmpty {
      VStack(alignment: .leading, spacing: 8) {
        Text(error)
          .font(.subheadline)
          .foregroundStyle(.secondary)

        Button("Reintentar") {
          Task { await viewModel.loadEvents() }
        }
        .foregroundColor(Color("PrimaryAdax"))
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    } else if viewModel.events.isEmpty {
      Text("No hay eventos este mes.")
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    } else {
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(spacing: 12) {
            ForEach(viewModel.events) { event in
              NavigationLink {
                EventDetailPage(event: event)
              } label: {
                EventCard(event: event)
              }
              .buttonStyle(.plain)
            }
        }
        // Keeps the first card aligned with the rest of the page
        .padding(.horizontal, screenPadding)
        // leaves room so the card shadow is not cut
        .padding(.vertical, 4)
      }
      .padding(.horizontal, -screenPadding)
    }
  }
}

extension EventsCarousel where Trailing == EmptyView {
  init(viewModel: EventsViewModel) {
    self.init(viewModel: viewModel) { EmptyView() }
  }
}

// Preview with fake events to see if it works good

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
        startsAt: "2026-10-28T17:00:00+00:00", endsAt: "2026-10-28T19:00:00+00:00",
        modality: "Presencial", location: "Sede Adax", imageUrl: nil),
      EventListItem(
        id: "3", title: "Aprende sobre tus derechos",
        description: "Taller informativo.",
        startsAt: "2026-10-30T16:00:00+00:00", endsAt: "2026-10-30T18:00:00+00:00",
        modality: "Virtual", location: nil, imageUrl: nil),
    ]
  }
}

private struct EventsCarouselPreview: View {
  @StateObject private var viewModel = EventsViewModel(
    scope: .month, getEventsUseCase: MockGetEventsUseCase())

  var body: some View {
    EventsCarousel(viewModel: viewModel) {
      Text("Agregar evento")
        .font(.subheadline)
        .foregroundColor(Color("PrimaryAdax"))
    }
    .padding(.horizontal, 20)
    .task { await viewModel.loadEvents() }
  }
}

#Preview {
  NavigationStack {
    ZStack(alignment: .top) {
      Color("Background").ignoresSafeArea()
      EventsCarouselPreview()
    }
  }
}
