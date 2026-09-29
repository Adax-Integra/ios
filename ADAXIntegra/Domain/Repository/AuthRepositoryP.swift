//
//  AuthRepositoryP.swift
//  ADAXIntegra
//
//  Created by Laura Cintora on 22/09/26.
//

// Domain/Repository/AuthRepositoryP.swift

import Foundation

protocol AuthRepositoryP {

  func login(
    email: String,
    password: String
  ) async -> LoginResult?
}
