//
//  RemoteCaseRepository.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 23/09/26.
//

import Foundation

struct RemoteCaseRepository: CaseRepository {
  func getCases(for userId: String) async throws -> [Case] {
    let response = try await APIProtocol.get(
      "/users/\(userId)/cases", as: APIResponse<[Case]>.self
    )
    return response.data
  }

  func createCase(_ newCase: NewCase, userId: String) async -> String? {
    do {
      let response = try await APIProtocol.post(
        "/external-users/\(userId)/cases",
        body: CreateCaseRequest(from: newCase),
        as: APIResponse<CreatedCaseModel>.self
      )

      return response.data.caseId
    } catch {
      // Any failure (no connection, 4xx, 5xx, bad JSON) is reported as nil.
      // The ViewModel decides what to show the user
      debugPrint(error.localizedDescription)
      return nil
    }
  }
}
