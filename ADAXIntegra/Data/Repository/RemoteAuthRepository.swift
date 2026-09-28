//
//  RemoteAuthRepository.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 24/09/26.
//

import Foundation

private struct LoginRequestBody: Encodable {
  let email: String
  let password: String
}

class RemoteAuthRepository: AuthRepositoryP {
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
}
