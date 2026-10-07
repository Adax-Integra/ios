//
//  RemoteCaseListRepository.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 24/09/26.
//

import Foundation

struct RemoteCaseListRepository: CaseListRepository {
  func listCases(
    page: Int,
    limit: Int,
    search: String,
    urgency: String
  ) async throws -> CaseListResult {
    var components = URLComponents()
    components.queryItems = [
      URLQueryItem(name: "page", value: String(page)),
      URLQueryItem(name: "limit", value: String(limit)),
      URLQueryItem(name: "search", value: search),
      URLQueryItem(name: "urgency", value: urgency),
    ]
    let query = components.percentEncodedQuery ?? ""

    let response = try await APIProtocol.get(
      "/cases?\(query)",
      as: APIResponse<CaseListResult>.self
    )
    return response.data
  }
}
