//
//  EventRepository.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 15/10/26.
//

import Foundation

protocol EventRepository {
  func createEvent(_ event: NewEvent) async throws -> Event
  func uploadEventImage(eventId: String, image: DocumentFile) async throws -> EventImage
  // E-03: hides the event from the calendar
  func disableEvent(eventId: String) async throws -> DisabledEvent
}
