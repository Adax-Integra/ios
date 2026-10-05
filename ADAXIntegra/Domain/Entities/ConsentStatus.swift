//
//  ConsentStatus.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 03/10/26.
//

import Foundation

struct ConsentStatus: Decodable {
  let hasAccepted: Bool
  let policyId: String
  let version: String
  // Nil when the user has not accepted the notice in force
  let acceptedAt: String?
}
