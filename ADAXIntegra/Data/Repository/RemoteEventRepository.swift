//
//  RemoteEventRepository.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 14/10/26.
//

import Foundation

class RemoteEventRepository: EventRepository {
  func disableEvent(eventId: String) async throws -> DisabledEvent {
    let response = try await APIProtocol.patch(
      "/events/\(eventId)/disable",
      as: APIResponse<DisabledEvent>.self
    )
    return response.data
  }
}
