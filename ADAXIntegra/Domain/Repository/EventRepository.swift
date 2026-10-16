//
//  EventRepository.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 14/10/26.
//

import Foundation

protocol EventRepository {
  // E-03: hides the event from the calendar
  func disableEvent(eventId: String) async throws -> DisabledEvent
}
