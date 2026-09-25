//
//  RemoteCaseRepository.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 23/09/26.
//

import Foundation

struct RemoteCaseRepository: CaseRepository {
    func getCases(for userId: String) async throws -> [Case] {
        let response = try await APIProtocol.get("/users/\(userId)/cases", as: APIResponse<[Case]>.self
        )
        return response.data
    }
}
