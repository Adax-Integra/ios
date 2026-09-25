//
//  LoginResult.swift
//  ADAXIntegra
//
//  Created by Laura Cintora Lopez on 22/09/26.
//

import Foundation

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

// Token: 5 days = 120 hours
