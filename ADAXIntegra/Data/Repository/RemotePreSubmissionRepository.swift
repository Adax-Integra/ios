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
      "/external-users/\(userId)/pre-submission",
      as: APIResponse<PreSubmission>.self)
    return response.data
  }

  func editPreSubmission(for userId: String, with preSubmission: PreSubmission) async throws
    -> PreSubmission
  {
    let response = try await APIProtocol.put(
      "/external-users/\(userId)/pre-submission",
      body: preSubmission,
      as: APIResponse<PreSubmission>.self)
    return response.data
  }
}
