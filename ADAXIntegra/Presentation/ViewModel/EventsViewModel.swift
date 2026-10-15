//
//  EventsViewModel.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 15/10/26.
//

import Combine
import Foundation

// One ViewModel for both screens of E-01  the carousel of the home page
// uses .month and the list page  uses .all
@MainActor
final class EventsViewModel: ObservableObject {
  @Published private(set) var events: [Event] = []
  @Published private(set) var isLoading = false
  @Published private(set) var errorMessage: String?

  private let scope: EventScope
  private let getEventsUseCase: GetEventsUseCaseProtocol

  init(
    scope: EventScope,
    getEventsUseCase: GetEventsUseCaseProtocol? = nil
  ) {
    self.scope = scope
    self.getEventsUseCase =
      getEventsUseCase
      ?? GetEventsUseCase(dataRepository: RemoteEventRepository())
  }

  func loadEvents() async {
    guard !isLoading else { return }

    isLoading = true
    errorMessage = nil
    defer { isLoading = false }

    do {
      let result = try await getEventsUseCase.getEvents(scope: scope)
      try Task.checkCancellation()
      events = result
    } catch {
      guard !Task.isCancelled else { return }
      errorMessage = "No se pudieron cargar los eventos."
    }
  }
}
