//
//  RemoteRecordListRepository.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 02/10/26.
//

import Foundation

struct RemoteRecordListRepository: RecordListRepository {
    func listRecords(page: Int, search: String, hasOpenCases: Bool?, status: String?) async throws -> RecordListResult {
        var components = URLComponents()
        var items: [URLQueryItem] = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "search", value: search),
        ]
        
        if let hasOpenCases {
            items.append(URLQueryItem(name: "hasOpen", value: String(hasOpenCases)))
        }
        
        if let status {
            items.append(URLQueryItem(name: "status", value: status))
        }
        components.queryItems = items
        let query = components.percentEncodedQuery ?? ""
        
        let response = try await APIProtocol.get(
            "/records?\(query)",
            as: APIResponse<RecordListResult>.self
        )
        return response.data
    }
}
