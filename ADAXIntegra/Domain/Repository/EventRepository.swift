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
}
