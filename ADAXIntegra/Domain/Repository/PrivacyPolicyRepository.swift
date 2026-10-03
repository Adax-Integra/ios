//
//  PrivacyPolicyRepository.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 03/10/26.
//

import Foundation

protocol PrivacyPolicyRepository {
  // GET /privacy-policy/current
  func getCurrentPolicy() async throws -> PrivacyPolicy
}
