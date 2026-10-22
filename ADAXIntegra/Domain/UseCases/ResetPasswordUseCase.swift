//
//  ResetPasswordUseCase.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 12/10/26.
//

import Foundation

protocol ResetPasswordUseCaseProtocol {
  func resetPassword(email: String, code: String, newPassword: String) async throws -> String?
}

// Changes the password with the code the user received by email
class ResetPasswordUseCase: ResetPasswordUseCaseProtocol {
  let dataRepository: PasswordRecoveryRepository

  init(dataRepository: PasswordRecoveryRepository) {
    self.dataRepository = dataRepository
  }

  func resetPassword(email: String, code: String, newPassword: String) async throws -> String? {
    // Same email format used when the code was requested
    let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    let cleanCode = code.trimmingCharacters(in: .whitespacesAndNewlines)

    let response = try await dataRepository.resetPassword(
      ResetPasswordRequest(email: cleanEmail, code: cleanCode, newPassword: newPassword)
    )
    return response.message
  }
}
