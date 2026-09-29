//
//  RemoteCreateCaseRepository.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 28/09/26.
//

import Foundation

// Backend implementation of CaseRepositoryP (R-02)
class RemoteCreateCaseRepository: CaseRepositoryP {
  // Single shared instance
  static let shared = RemoteCreateCaseRepository()

  func createCase(_ newCase: CaseEntity, userId: String) async -> String? {
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
