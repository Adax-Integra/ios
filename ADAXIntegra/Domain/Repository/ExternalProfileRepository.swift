//
//  ExternalProfileRepository.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 05/10/26.
//

import Foundation

protocol ExternalProfileRepository {
  func getExternalProfile(for userId: String) async throws -> ExternalUserProfile

  func updateExternalProfile(for userId: String, with request: UpdateExternalProfileRequest)
    async throws -> ExternalUserProfile
}
