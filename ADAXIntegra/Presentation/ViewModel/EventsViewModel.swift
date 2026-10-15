//
//  EventsViewModel.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 15/10/26.
//

import Combine
import Foundation

// One ViewModel for both the carouseland  the list
@MainActor
final class EventsViewModel: ObservableObject {
  @Published private(set) var events: [EventListItem] = []
  @Published private(set) var isLoading = false
  @Published private(set) var errorMessage: String?

  private let scope: EventScope
  private let getEventsUseCase: GetEventsUseCaseProtocol

  // Initializes the view model with a scope and an optional custom use case
  init(
    scope: EventScope,
    getEventsUseCase: GetEventsUseCaseProtocol? = nil
  ) {
    self.scope = scope
    self.getEventsUseCase =
      getEventsUseCase
      ?? GetEventsUseCase(dataRepository: RemoteEventListRepository())
  }

  // Fetches events asynchronously and updates the view state accordingly
  func loadEvents() async {
    guard !isLoading else { return }

    isLoading = true
    errorMessage = nil
    defer { isLoading = false }

    do {
      // Execute the use case to fetch events for the current scope
      let result = try await getEventsUseCase.getEvents(scope: scope)
      try Task.checkCancellation()
      events = result
    } catch {
      guard !Task.isCancelled else { return }
      errorMessage = "No se pudieron cargar los eventos."

    }
  }
}
