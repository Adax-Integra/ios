//
//  UpdateEventUseCase.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 16/10/26.
//

import Foundation

protocol UpdateEventUseCaseProtocol {
  func updateEvent(eventId: String, event: NewEvent) async throws -> Event
}

class UpdateEventUseCase: UpdateEventUseCaseProtocol {
  let dataRepository: EventRepository

  init(dataRepository: EventRepository) {
    self.dataRepository = dataRepository
  }

  func updateEvent(eventId: String, event: NewEvent) async throws -> Event {
    try await dataRepository.updateEvent(eventId: eventId, event: event)
  }
}
