//
//  CreateAccountModel.swift
//
//
//  Created by Lakshmi Jara on 24/09/26.
//
// G-01

import Foundation

struct CreateAccountRequestModel: Encodable {
  let name: String
  let lastName: String
  let email: String
  let countryCode: String
  let phone: String
  let password: String
  let confirmPassword: String

  enum CodingKeys: String, CodingKey {
    case name
    case lastName = "last_name"
    case email
    case countryCode = "country_code"
    case phone
    case password
    case confirmPassword = "confirm_password"
  }
}

struct CreateAccountResponseModel: Decodable {
  let success: Bool
  let data: CreateAccountDataModel
}

struct CreateAccountDataModel: Decodable {
  let userId: String
  let name: String
  let lastName: String
  let email: String
  let phone: String
}

struct CreateAccountErrorModel: Decodable {
  let success: Bool
  let error: String
}
