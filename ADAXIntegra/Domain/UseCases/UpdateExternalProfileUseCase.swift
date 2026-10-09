//
//  UpdateExternalProfileUseCase.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 05/10/26.
//

import Foundation

protocol UpdateExternalProfileUseCaseProtocol {
  func updateExternalProfile(
    for userId: String,
    with request: UpdateExternalProfileRequest
  ) async throws -> ExternalUserProfile
}

// Business rule for G-07: the admin updates the text data of an extrnal user
// Field validation lives in the ViewModel and is repeated by the backend
class UpdateExternalProfileUseCase: UpdateExternalProfileUseCaseProtocol {
  let dataRepository: ExternalProfileRepository
  init(dataRepository: ExternalProfileRepository) {
    self.dataRepository = dataRepository
  }

  func updateExternalProfile(
    for userId: String,
    with request: UpdateExternalProfileRequest
  ) async throws -> ExternalUserProfile {
    try await dataRepository.updateExternalProfile(for: userId, with: request)
  }
}
