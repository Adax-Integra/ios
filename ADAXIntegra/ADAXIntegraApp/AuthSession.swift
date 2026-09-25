//
//  AuthSession.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 24/09/26.
//

import Combine
import Foundation

@MainActor
class AuthSession: ObservableObject {
  @Published private(set) var token: String?
  @Published private(set) var userId: String?
  @Published private(set) var roles: [String] = []

  var isLoggedIn: Bool { token != nil }

  func login(with result: LoginResult) {
    token = result.token
    userId = result.userId
    roles = result.roles
  }

  func logout() {
    token = nil
    userId = nil
    roles = []
  }
}
