//
//  EventsListPage.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 15/10/26.
//

import SwiftUI

// Events list page that shows every active event, same for internal and external users
struct EventsListPage: View {
  // View model that manages the UI state and event data load
  @StateObject private var viewModel: EventsViewModel
  @EnvironmentObject private var session: AuthSession
  // E-03: confirmation and result of disabling an event
  @StateObject private var disableViewModel = DisableEventViewModel()
  // E-02: last event opened in the form, it is kept so the page does not go blank while closing
  @State private var eventToEdit: EventListItem?
  @State private var isEditingEvent = false

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
          // Same subtitle style as PageHeader, only internal users and admins manage events
          if canDisableEvents {
            Text("Gestiona los eventos de la asociación")
              .font(.subheadline)
              .foregroundColor(Color("OnBackground").opacity(0.7))
          }

          content
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
      }
      // Enables refresh with sliding down
      .refreshable {
        await viewModel.loadEvents()
      }
      // E-03: the screen is dimmed while the confirmation is shown
      if disableViewModel.isShowingConfirmation {
        Color.black.opacity(0.4)
          .ignoresSafeArea()
          .onTapGesture {
            if !disableViewModel.isDisabling { disableViewModel.onCancel() }
          }
        DisableEventDialog(
          isLoading: disableViewModel.isDisabling,
          onConfirm: { Task { await disableViewModel.confirm() } },
          onCancel: { disableViewModel.onCancel() }
        )
      }
    }
    .navigationTitle("Eventos")
    // Asynchronously loads events when the view appears
    .task {
      await viewModel.loadEvents()
    }
    // E-03: after "Entendido" the list is loaded again so the event disappears
    .fullScreenCover(isPresented: $disableViewModel.isShowingSuccess) {
      EventSuccessPage(
        title: "Evento deshabilitado",
        message: "El evento ya no aparece en el calendario.",
        onFinish: {
          disableViewModel.isShowingSuccess = false
          Task { await viewModel.loadEvents() }
        }
      )
    }
    // E-02: after saving, the list is loaded again so the card shows the changes
    .navigationDestination(isPresented: $isEditingEvent) {
      if let eventToEdit {
        CreateEventPage(
          event: eventToEdit,
          onSaved: { Task { await viewModel.loadEvents() } }
        )
      }
    }
    .toast(isPresented: $disableViewModel.showToast, message: disableViewModel.toastMessage)
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
          NavigationLink {
            EventDetailPage(event: event)
          } label: {
            EventListCard(event: event)
              .overlay(alignment: .topTrailing) {
                if canDisableEvents {
                  HStack(spacing: 0) {
                    editButton(for: event)
                    disableMenu(for: event)
                  }
                }
              }
          }
          .buttonStyle(.plain)
        }
      }
    }
  }
  // E-03: only internal users and admins can disable an event
  private var canDisableEvents: Bool {
    session.roles.contains("admin") || session.roles.contains("internal")
  }

  // E-02: same look as the disable button, only the vertical padding so both stay close
  private func editButton(for event: EventListItem) -> some View {
    Button {
      eventToEdit = event
      isEditingEvent = true
    } label: {
      Image(systemName: "pencil")
        .font(.system(size: 16, weight: .semibold))
        .foregroundColor(Color("PrimaryAdax"))
        .frame(width: 32, height: 32)
        .background(Circle().fill(Color.white))
        .padding(.vertical, 10)
    }
    .buttonStyle(.plain)
  }

  private func disableMenu(for event: EventListItem) -> some View {
    Button {
      disableViewModel.onDisableTapped(eventId: event.id)
    } label: {
      Image(systemName: "calendar.badge.minus")
        .font(.system(size: 16, weight: .semibold))
        .foregroundColor(Color("Error"))
        .frame(width: 32, height: 32)
        .background(Circle().fill(Color.white))
        .padding(10)
    }
    .buttonStyle(.plain)
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
  .environmentObject(AuthSession())
}
