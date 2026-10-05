//
//  PrivacyPolicy.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 03/10/26.
//

import Foundation

struct PrivacyPolicy: Decodable {
  let policyId: String
  let version: String
  // Nil when the notice has no PDF uploaded yet
  let documentUrl: String?
}
