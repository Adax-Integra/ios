//
//  RemoteEmailVerificationRepository.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 14/10/26.
//

import Foundation

// Talks to the backend to verify the email of a new account
struct RemoteEmailVerificationRepository: EmailVerificationRepository {
  func verifyEmail(_ request: VerifyEmailRequest) async throws -> LoginResult {
    let response = try await APIProtocol.post(
      "/auth/verify-email",
      body: request,
      as: APIResponse<LoginResult>.self
    )
    return response.data
  }

  func resendVerification(_ request: ResendVerificationRequest) async throws
    -> ResendVerificationResponse
  {
    let response = try await APIProtocol.post(
      "/auth/resend-verification",
      body: request,
      as: APIResponse<ResendVerificationResponse>.self
    )
    return response.data
  }
}
