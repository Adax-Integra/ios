//
//  RemoteExternalUserListRepository.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 16/10/26.
//

import Foundation

struct RemoteExternalUserListRepository: ExternalUserListRepository {
  // G-16: GET /internal-users/external-users with the page, search and filters
  func listExternalUsers(
    page: Int,
    search: String,
    status: String,
    sort: String
  ) async throws -> ExternalUserListResult {
    var components = URLComponents()
    components.queryItems = [
      URLQueryItem(name: "page", value: String(page)),
      URLQueryItem(name: "search", value: search),
      URLQueryItem(name: "status", value: status),
      URLQueryItem(name: "sort", value: sort),
    ]
    let query = components.percentEncodedQuery ?? ""

    let response = try await APIProtocol.get(
      "/internal-users/external-users?\(query)",
      as: APIResponse<ExternalUserListResult>.self
    )
    return response.data
  }
}
