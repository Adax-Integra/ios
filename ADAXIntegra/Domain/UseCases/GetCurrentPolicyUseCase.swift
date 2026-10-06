//
//  GetCurrentPolicyUseCase.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 03/10/26.
//

import Foundation

protocol GetCurrentPolicyUseCaseProtocol {
  func getCurrentPolicy() async throws -> PrivacyPolicy
}

// V-02: gets the privacy notice in force, the one the user reads before consenting
class GetCurrentPolicyUseCase: GetCurrentPolicyUseCaseProtocol {
  let dataRepository: PrivacyPolicyRepository

  init(dataRepository: PrivacyPolicyRepository) {
    self.dataRepository = dataRepository
  }

  func getCurrentPolicy() async throws -> PrivacyPolicy {
    try await dataRepository.getCurrentPolicy()
  }
}
