//
//  MockAuthRepository.swift
//  ADAXIntegra
//
//  Created by Laura Cintora on 22/09/26.
//

import Foundation

struct MockAuthRepository: AuthRepositoryP {

  // Simulates a login response for testing
  func login(
    email: String,
    password: String
  ) async -> LoginResult? {

  }
}
