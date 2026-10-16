//
//  EmailVerificationRepository.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 14/10/26.
//

import Foundation

protocol EmailVerificationRepository {

  // Checks the 6 digit code when it is right and the backend returns the session

  func verifyEmail(_ request: VerifyEmailRequest) async throws -> LoginResult

  // Asks the backend to email a new verification code

  func resendVerification(_ request: ResendVerificationRequest) async throws
    -> ResendVerificationResponse
}
