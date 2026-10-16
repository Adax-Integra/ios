//
//  DisableEventUseCase.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 14/10/26.
//

import Foundation

protocol DisableEventUseCaseProtocol {
  func execute(eventId: String) async throws -> DisabledEvent
}

// E-03: the collaborator removes a cancelled event from the calendar
class DisableEventUseCase: DisableEventUseCaseProtocol {
  let repository: EventRepository

  init(repository: EventRepository) {
    self.repository = repository
  }

  func execute(eventId: String) async throws -> DisabledEvent {
    try await repository.disableEvent(eventId: eventId)
  }
}
