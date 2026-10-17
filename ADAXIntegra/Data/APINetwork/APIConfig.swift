//
//  APIConfig.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 23/09/26.
//

enum APIConfig {
  // Flip to true to hit the local backend while the server is not deployed (R-09 testing).
  static let useLocalBackend = false

  static let baseURL =
    useLocalBackend
    ? "http://localhost:3001/api"
    : "https://dev-api.adaxdigitales.com/api"

  // Set by AuthSession after login; sent as "Authorization: Bearer <token>"
  static var token: String?
}
