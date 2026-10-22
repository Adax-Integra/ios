//
//  ResendVerificationUseCase.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 14/10/26.
//

import Foundation

protocol ResendVerificationUseCaseProtocol {
  func resendVerification(email: String) async throws -> String?
}

// asks the backend to email a new verification code
class ResendVerificationUseCase: ResendVerificationUseCaseProtocol {
  let dataRepository: EmailVerificationRepository

  init(dataRepository: EmailVerificationRepository) {
    self.dataRepository = dataRepository
  }

  func resendVerification(email: String) async throws -> String? {
    // Same email format used when the account was created
    let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

    let response = try await dataRepository.resendVerification(
      ResendVerificationRequest(email: cleanEmail)
    )
    return response.message
  }
}
