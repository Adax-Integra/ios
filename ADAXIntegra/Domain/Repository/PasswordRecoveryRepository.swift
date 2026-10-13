//
//  PasswordRecoveryRepository.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 12/10/26.
//

import Foundation

protocol PasswordRecoveryRepository {
  // Ask the backend to send the 6 digit code
  func requestResetCode(_ request: ForgotPasswordRequest) async throws -> PasswordRecoveryResponse
  // Sends the code and new password to change it
  func resetPassword(_ request: ResetPasswordRequest) async throws -> PasswordRecoveryResponse
}
