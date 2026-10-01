//
//  RemotePreSubmissionRepository.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 01/10/26.
//

import Foundation

struct RemotePreSubmissionRepository: PreSubmissionRepository {
  func getPreSubmission(for userId: String) async throws -> PreSubmission {
    let response = try await APIProtocol.get(
      "external-users/\(userId)/pre-submission",
      as: APIResponse<PreSubmission>.self)
    return response.data
  }
}
