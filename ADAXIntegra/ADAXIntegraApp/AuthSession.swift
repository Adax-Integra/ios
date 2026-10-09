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

  private struct StoredSession: Codable {
    let token: String
    let userId: String
    let roles: [String]
    let expiresAt: Date
  }

  private let storageKey = "session"

  // seconds (5 days)
  private let sessionLifetime: TimeInterval = 120 * 60 * 60

  init() { restore() }

  func login(with result: LoginResult) {
    token = result.token
    userId = result.userId
    roles = result.roles
    // Makes the token available to every request sent through APIProtocol
    APIConfig.token = result.token
    persist()
  }

  func logout() {
    token = nil
    userId = nil
    roles = []
    // Requests after logout go out without credentials
    APIConfig.token = nil
    UserDefaults.standard.removeObject(forKey: storageKey)
  }

  private func persist() {
    guard
      let token,
      let userId
    else { return }
    let stored = StoredSession(
      token: token,
      userId: userId,
      roles: roles,
      expiresAt: Date().addingTimeInterval(sessionLifetime)
    )
    if let data = try? JSONEncoder().encode(stored) {
      UserDefaults.standard.set(data, forKey: storageKey)
    }
  }

  private func restore() {
    guard
      let data = UserDefaults.standard.data(forKey: storageKey),
      let stored = try? JSONDecoder().decode(StoredSession.self, from: data)
    else { return }

    guard stored.expiresAt > Date() else {
      UserDefaults.standard.removeObject(forKey: storageKey)
      return
    }

    token = stored.token
    userId = stored.userId
    roles = stored.roles
    APIConfig.token = stored.token
  }
}
