//
//  RemoteEventListRepository.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 15/10/26.
//
import Foundation

// Reads the active events through the backend (GET /events)
struct RemoteEventListRepository: EventListRepository {
  func fetchEvents(scope: EventScope) async throws -> [EventListItem] {

    let path = scope == .month ? "/events?scope=month" : "/events"
    let response = try await APIProtocol.get(
      path, as: APIResponse<[EventListItem]>.self)

    // Skip events whose date cannot be read, so a wrong date is never shown
    return response.data.filter { $0.startDate != nil }
  }
}
