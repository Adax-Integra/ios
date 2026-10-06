//
//  RemoteProfileRepository.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 06/10/26.
//

import Foundation

struct RemoteProfileRepository: ProfileRepository {
  func getProfile(for userId: String) async throws -> UserProfile {
    let response = try await APIProtocol.get(
      "/profile/\(userId)", as: APIResponse<UserProfile>.self
    )
    return response.data
  }
}
