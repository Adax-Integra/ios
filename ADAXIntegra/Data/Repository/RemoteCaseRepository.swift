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
    
    // V11 implementation, function that fetches full details for a single case by its ID
    // we recieve the case ID and return an object with the details of said case ID
    // it throws an error if the request or decoding fails
    
    func getCaseDetail(caseId: String) async throws -> CaseDetail {
      let response = try await APIProtocol.get(
        "/cases/\(caseId)", as: APIResponse<CaseDetail>.self
      )
      return response.data
    }
    // V11 implementation, function that sends a request to close an open case
    // we recieve the case ID and return a boolean that tells if the closing of a case was succesfull or not
    // it throws an error if the request fails

    func closeCase(caseId: String) async throws -> Bool {
      let response = try await APIProtocol.patch(
        "/cases/\(caseId)/close", as: APIResponse<CloseCaseResult>.self
      )
      return response.success
    }
}
