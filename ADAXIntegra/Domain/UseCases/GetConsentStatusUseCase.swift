//
//  GetConsentStatusUseCase.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 03/10/26.
//

import Foundation

protocol GetConsentStatusUseCaseProtocol {
  func getConsentStatus() async throws -> ConsentStatus
}

// V-02: tells whether the logged-in user already accepted the notice in force
class GetConsentStatusUseCase: GetConsentStatusUseCaseProtocol {
  let dataRepository: PrivacyPolicyRepository

  init(dataRepository: PrivacyPolicyRepository) {
    self.dataRepository = dataRepository
  }

  func getConsentStatus() async throws -> ConsentStatus {
    try await dataRepository.getConsentStatus()
  }
}
