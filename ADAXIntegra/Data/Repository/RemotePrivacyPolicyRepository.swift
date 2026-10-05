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

  func getConsentStatus() async throws -> ConsentStatus {
    let response = try await APIProtocol.get(
      "/privacy-policy/consent", as: APIResponse<ConsentStatus>.self
    )
    return response.data
  }

  func registerConsent(policyId: String) async throws -> ConsentRecord {
    let response = try await APIProtocol.post(
      "/privacy-policy/consent",
      body: ConsentRequestBody(policyId: policyId),
      as: APIResponse<ConsentRecord>.self
    )
    return response.data
  }
}
