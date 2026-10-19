//
//  RemoteAuthRepository.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 24/09/26.
//

import Foundation

class RemoteAuthRepository: AuthRepository {

  // G-09: lets the error through, so the view model can read codes like EMAIL_NOT_VERIFIED

  func login(email: String, password: String) async throws -> LoginResult {
    let response = try await APIProtocol.post(
      "/auth/login",
      body: LoginRequestBody(
        email: email,
        password: password),
      as: APIResponse<LoginResult>.self
    )
    return response.data
  }

  func changePassword(currentPassword: String, newPassword: String, confirmPassword: String)
    async throws -> ChangePasswordResult
  {
    let response = try await APIProtocol.post(
      "/auth/change-password",
      body: ChangePasswordRequestBody(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword),
      as: APIResponse<ChangePasswordResult>.self
    )
    return response.data
  }

  func logout() async throws {
    _ = try await APIProtocol.post(
      "/auth/logout",
      body: EmptyBody(),
      as: APIResponse<LogoutResult>.self
    )
  }

  func deactivateAccount(userId: String) async throws {
    _ = try await APIProtocol.patch(
      "/profile/\(userId)/deactivate",
      as: APIResponse<DeactivateAccountResult>.self
    )
  }
}
