//
//  GetEventsUseCase.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 15/10/26.
//

import Foundation

protocol GetEventsUseCaseProtocol {
  func getEvents(scope: EventScope) async throws -> [Event]
}

struct GetEventsUseCase: GetEventsUseCaseProtocol {
  let dataRepository: EventRepository

  func getEvents(scope: EventScope) async throws -> [Event] {
    try await dataRepository.fetchEvents(scope: scope)
  }
}
