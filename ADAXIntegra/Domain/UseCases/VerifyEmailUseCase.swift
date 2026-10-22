//
//  VerifyEmailUseCase.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 14/10/26.
//

import Foundation

protocol VerifyEmailUseCaseProtocol {
  func verifyEmail(email: String, code: String) async throws -> LoginResult
}

// checks the code sent to the email and when it is right returns the session
class VerifyEmailUseCase: VerifyEmailUseCaseProtocol {
  let dataRepository: EmailVerificationRepository

  init(dataRepository: EmailVerificationRepository) {
    self.dataRepository = dataRepository
  }

  func verifyEmail(email: String, code: String) async throws -> LoginResult {
    // The backend stores emails in lowercase and without spaces
    let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    let cleanCode = code.trimmingCharacters(in: .whitespacesAndNewlines)

    return try await dataRepository.verifyEmail(
      VerifyEmailRequest(email: cleanEmail, code: cleanCode)
    )
  }
}
