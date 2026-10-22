//
//  RemotePasswordRecoveryRepository.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 12/10/26.
//

import Foundation

// talks to the backend and trys to recover a forgotten password

struct RemotePasswordRecoveryRepository: PasswordRecoveryRepository {
  func requestResetCode(_ request: ForgotPasswordRequest) async throws -> PasswordRecoveryResponse {
    let response = try await APIProtocol.post(
      "/password-recovery/forgot-password",
      body: request,
      as: APIResponse<PasswordRecoveryResponse>.self
    )
    return response.data
  }

  func resetPassword(_ request: ResetPasswordRequest) async throws -> PasswordRecoveryResponse {
    let response = try await APIProtocol.post(
      "/password-recovery/reset-password",
      body: request,
      as: APIResponse<PasswordRecoveryResponse>.self

    )
    return response.data
  }
}
