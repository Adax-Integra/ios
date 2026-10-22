//
//  Login.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 03/10/26.
//

import Foundation

struct LoginRequestBody: Encodable {
  let email: String
  let password: String
}

struct LoginResult: Decodable {
  let token: String
  let userId: String
  let roles: [String]

  enum CodingKeys: String, CodingKey {
    case token
    case userId = "user_id"  // backend sends snakecase for some reason
    case roles
  }
}

struct EmptyBody: Encodable {}

struct LogoutResult: Decodable {
  let message: String
}

struct DeactivateAccountResult: Decodable {
  let userId: String?
  let deactivatedAt: String?
}

// Token: 5 days = 120 hours
