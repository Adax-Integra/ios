//
//  RemoteExternalProfileRepository.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 05/10/26.
//

import Foundation

// Backend implementation of ExternalProfileRepository (G-07)
struct RemoteExternalProfileRepository: ExternalProfileRepository {
  func getExternalProfile(for userId: String) async throws -> ExternalUserProfile {
    let response = try await APIProtocol.get(
      "/internal-users/external-users/\(userId)",
      as: APIResponse<ExternalUserProfile>.self)
    return response.data
  }

  func updateExternalProfile(for userId: String, with request: UpdateExternalProfileRequest)
    async throws -> ExternalUserProfile
  {
    let response = try await APIProtocol.patch(
      "/internal-users/external-users/\(userId)",
      body: request,
      as: APIResponse<ExternalUserProfile>.self)
    return response.data
  }
}
