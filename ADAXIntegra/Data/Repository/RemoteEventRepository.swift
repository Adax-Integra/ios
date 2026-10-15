//
//  RemoteEventRepository.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 15/10/26.
//

import Foundation

struct RemoteEventRepository: EventRepository {
  func fetchEvents(scope: EventScope) async throws -> [Event] {
    // The token is added by APIProtocol
    let path = scope == .month ? "/events?scope=month" : "/events"
    let response = try await APIProtocol.get(
      path, as: APIResponse<[Event]>.self)

    // Skip events whose date cannot be read in this way we make sure
    // that a wrong date is never shown to the final users
      
    return response.data.filter { $0.startDate != nil }
  }
}
