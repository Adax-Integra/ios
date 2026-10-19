//
//  RemoteActivityLogRepository.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 18/10/26.
//

import Foundation

struct RemoteActivityLogRepository: ActivityLogRepository {
  // The backend asks for ISO 8601 with time zone
  private static let isoFormatter = ISO8601DateFormatter()

  func listActivityLog(page: Int, from: Date?, to: Date?) async throws -> ActivityLogResult {
    var components = URLComponents()
    var items: [URLQueryItem] = [URLQueryItem(name: "page", value: String(page))]

    // "from" and "to" are optional, they are only sent when the filter is active
    if let from {
      items.append(URLQueryItem(name: "from", value: Self.isoFormatter.string(from: from)))
    }
    if let to {
      items.append(URLQueryItem(name: "to", value: Self.isoFormatter.string(from: to)))
    }
    components.queryItems = items
    let query = components.percentEncodedQuery ?? ""

    // APIProtocol adds the Bearer token automatically
    let response = try await APIProtocol.get(
      "/internal-users/activity-log?\(query)",
      as: APIResponse<ActivityLogResult>.self
    )
    return response.data
  }
}
