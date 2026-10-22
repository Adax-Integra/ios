//
//  CreateEventUseCase.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 15/10/26.
//

import Foundation

protocol CreateEventUseCaseProtocol {
  func createEvent(_ event: NewEvent) async throws -> Event
}

class CreateEventUseCase: CreateEventUseCaseProtocol {
  let dataRepository: EventRepository

  init(dataRepository: EventRepository) {
    self.dataRepository = dataRepository
  }

  func createEvent(_ event: NewEvent) async throws -> Event {
    try await dataRepository.createEvent(event)
  }
}
