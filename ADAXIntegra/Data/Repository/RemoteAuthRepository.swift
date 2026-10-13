//
//  RemoteAuthRepository.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 24/09/26.
//

import Foundation

class RemoteAuthRepository: AuthRepository {
  func login(email: String, password: String) async -> LoginResult? {
    do {
      let response = try await APIProtocol.post(
        "/auth/login",
        body: LoginRequestBody(
          email: email,
          password: password),
        as: APIResponse<LoginResult>.self
      )
      return response.data
    } catch {
      print(error)
      return nil
    }
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
}
