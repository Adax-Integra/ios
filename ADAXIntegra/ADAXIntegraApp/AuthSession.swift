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

  private let authRepository: AuthRepository

  // seconds (5 days)
  private let sessionLifetime: TimeInterval = 167 * 60 * 60

  init(authRepository: AuthRepository = RemoteAuthRepository()) {
    self.authRepository = authRepository
    restore()
  }

  func login(with result: LoginResult) {
    token = result.token
    userId = result.userId
    roles = result.roles
    // Makes the token available to every request sent through APIProtocol
    APIConfig.token = result.token
    persist()
  }

  func logout() async {
    defer { clearSession() }

    do {
      try await authRepository.logout()
    } catch APIError.server(let statusCode, let data) {
      let body = String(data: data ?? Data(), encoding: .utf8) ?? ""
      debugPrint("Logout falló. Status: \(statusCode). Respuesta: \(body)")
    } catch {
      debugPrint(error.localizedDescription)
    }
  }

  func deactivateAccount() async -> Bool {
    guard let userId else { return false }
    do {
      try await authRepository.deactivateAccount(userId: userId)
      clearSession()
      return true
    } catch {
      debugPrint(error)
      return false
    }
  }

  private func clearSession() {
    token = nil
    userId = nil
    roles = []
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
    UserDefaults.standard.removeObject(forKey: storageKey)
  }
}
