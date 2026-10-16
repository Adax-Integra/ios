//
//  GetEventsUseCase.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 15/10/26.
//

import Foundation

// Protocol defining for retrieving events
protocol GetEventsUseCaseProtocol {
  func getEvents(scope: EventScope) async throws -> [EventListItem]
}

//  implementation of the use case for fetching events
class GetEventsUseCase: GetEventsUseCaseProtocol {
  let dataRepository: EventListRepository

  init(dataRepository: EventListRepository) {
    self.dataRepository = dataRepository
  }

  // Executes the asynchronous operation to retrieve events for a specific scope
  func getEvents(scope: EventScope) async throws -> [EventListItem] {
    try await dataRepository.fetchEvents(scope: scope)
  }
}
