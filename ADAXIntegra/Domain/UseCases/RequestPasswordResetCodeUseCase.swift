//
//  RequestPasswordResetCodeUseCase.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 12/10/26.
//

import Foundation

protocol RequestPasswordResetCodeUseCaseProtocol {
  func requestResetCode(email: String) async throws -> String?
}

class RequestPasswordResetCodeUseCase: RequestPasswordResetCodeUseCaseProtocol {
  let dataRepository: PasswordRecoveryRepository

  init(dataRepository: PasswordRecoveryRepository) {
    self.dataRepository = dataRepository
  }

  func requestResetCode(email: String) async throws -> String? {
    // Backend stores emails in lowarecase withpout spaces
    let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

    let response = try await dataRepository.requestResetCode(
      ForgotPasswordRequest(email: cleanEmail)
    )
    return response.message
  }
}
