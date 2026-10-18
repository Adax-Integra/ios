//
//  CollaboratorDetail.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 17/10/26.
////
//  CollaboratorDetail.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 17/10/26.
//

import Foundation

// G-10: Detail of one collaborator, as sent by GET /internal-users/{userId}
struct CollaboratorDetail: Decodable, Identifiable, Equatable {
  let id: String
  let name: String
  let lastName: String
  // The backend already builds the full name and the avatar initials
  let fullName: String
  let initials: String
  let email: String
  let phone: String?
  // Role name stored in the database (for now, only "internal")
  let role: String
  // Null when the collaborator has no office assigned
  let office: String?
  // "yyyy-MM-dd", the ViewModel formats it for the screen
  let joinedAt: String
  // False when the account was deleted
  let isActive: Bool

  // The API uses snake_case and the decoder has no key strategy
  enum CodingKeys: String, CodingKey {
    case id = "user_id"
    case name
    case lastName = "last_name"
    case fullName = "full_name"
    case initials
    case email
    case phone
    case role
    case office
    case joinedAt = "joined_at"
    case isActive = "is_active"
  }
}
