//
//  UserProfile.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 06/10/26.
//

import Foundation

// Only the fields the profile screen shows are decoded
struct UserProfile: Decodable {
  let name: String
  let lastName: String
  let createdAt: String

  enum CodingKeys: String, CodingKey {
    case name
    case lastName = "last_name"
    case createdAt = "created_at"
  }
}
