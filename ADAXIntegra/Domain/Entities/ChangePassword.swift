//
//  ChangePassword.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 07/10/26.
//

import Foundation

struct ChangePasswordRequestBody: Encodable {
  let currentPassword: String
  let newPassword: String
  let confirmPassword: String

  enum CodingKeys: String, CodingKey {
    case currentPassword = "current_password"
    case newPassword = "new_password"
    case confirmPassword = "confirm_password"
  }
}

struct ChangePasswordResult: Decodable {
  let message: String
}
