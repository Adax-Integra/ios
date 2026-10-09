//
//  RegisterConsentUseCase.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 03/10/26.
//

import Foundation

protocol RegisterConsentUseCaseProtocol {
  func registerConsent(policyId: String) async throws -> ConsentRecord
}

// V-02: records that the logged-in user accepted the notice with that id
class RegisterConsentUseCase: RegisterConsentUseCaseProtocol {
  let dataRepository: PrivacyPolicyRepository

  init(dataRepository: PrivacyPolicyRepository) {
    self.dataRepository = dataRepository
  }

  func registerConsent(policyId: String) async throws -> ConsentRecord {
    try await dataRepository.registerConsent(policyId: policyId)
  }
}
