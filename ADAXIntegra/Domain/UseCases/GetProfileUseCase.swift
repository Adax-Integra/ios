//
//  GetProfileUseCase.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 06/10/26.
//

import Foundation

protocol GetProfileUseCaseProtocol {
  func getProfile(for userId: String) async throws -> UserProfile
}

// G-13: gets the data of the logged-in user shown in the profile tab
class GetProfileUseCase: GetProfileUseCaseProtocol {
  let dataRepository: ProfileRepository

  init(dataRepository: ProfileRepository) {
    self.dataRepository = dataRepository
  }

  func getProfile(for userId: String) async throws -> UserProfile {
    try await dataRepository.getProfile(for: userId)
  }
}
