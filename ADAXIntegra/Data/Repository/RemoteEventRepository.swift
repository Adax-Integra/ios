//
//  RemoteEventRepository.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 15/10/26.
//

import Foundation

// Creates events and uploads their image through the backend
struct RemoteEventRepository: EventRepository {

  func createEvent(_ event: NewEvent) async throws -> Event {
    let response = try await APIProtocol.post(
      "/events", body: event, as: APIResponse<Event>.self
    )
    return response.data
  }

  func uploadEventImage(eventId: String, image: DocumentFile) async throws -> EventImage {
    let response = try await APIProtocol.patchMultipart(
      "/events/\(eventId)/image", files: ["image": image], as: APIResponse<EventImage>.self
    )
    return response.data
  }
}
