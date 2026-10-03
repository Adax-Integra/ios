//
//  RemotePrivacyPolicyRepository.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 03/10/26.
//

import Foundation

struct RemotePrivacyPolicyRepository: PrivacyPolicyRepository {
  func getCurrentPolicy() async throws -> PrivacyPolicy {
    let response = try await APIProtocol.get(
      "/privacy-policy/current", as: APIResponse<PrivacyPolicy>.self
    )
    // The backend wraps the notice as { success, data }, so only "data" is returned
    return response.data
  }
}
