//
//  GetExternalProfileUseCase.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 05/10/26.
//

import Foundation

protocol GetExternalProfileUseCaseProtocol {
  func getExternalProfile(for userId: String) async throws -> ExternalUserProfile
}

class GetExternalProfileUseCase: GetExternalProfileUseCaseProtocol {
  let dataRepository: ExternalProfileRepository

  init(dataRepository: ExternalProfileRepository) {
    self.dataRepository = dataRepository
  }

  func getExternalProfile(for userId: String) async throws -> ExternalUserProfile {
    try await dataRepository.getExternalProfile(for: userId)
  }
}
