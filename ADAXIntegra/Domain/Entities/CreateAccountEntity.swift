//
//  CreateAccountEntity.swift
//
//
//  Created by Lakshmi Jara on 24/09/26.
//
// G-01

import Foundation

// data entered by the user in the form
struct CreateAccountInput {
  let name: String
  let lastName: String
  let email: String
  let countryCode: String
  let phone: String
  let password: String
  let confirmPassword: String
}

// user data returned by the backend
struct CreateAccountEntity {
  let userId: String
  let name: String
  let lastName: String
  let email: String
  let phone: String
}
