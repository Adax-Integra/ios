//
//  AuthRepositoryP.swift
//  ADAXIntegra
//
//  Created by Laura Cintora on 22/09/26.
//

// Domain/Repository/AuthRepository.swift

import Foundation

protocol AuthRepository {
  func login(email: String, password: String) async -> LoginResult?
}
