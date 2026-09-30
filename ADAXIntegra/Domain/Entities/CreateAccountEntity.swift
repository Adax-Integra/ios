//
//  CreateAccountEntity.swift
//
//
//  Created by Lakshmi Jara on 24/09/26.
//
// G-01

import Foundation

// groups the information entered in the registration form
struct CreateAccountInput {
  let name: String
  let lastName: String
  let email: String
  let countryCode: String
  let phone: String
  let password: String
  let confirmPassword: String
}

// holds the account information retured by the repository after registration
struct CreateAccountEntity {
  let userId: String
  let name: String
  let lastName: String
  let email: String
  let phone: String
}
