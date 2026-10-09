//
//  APIConfig.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 23/09/26.
//

enum APIConfig {
  static let baseURL = "https://adax-integra.duckdns.org/api"

  // Set by AuthSession after login; sent as "Authorization: Bearer <token>"
  static var token: String?
}
