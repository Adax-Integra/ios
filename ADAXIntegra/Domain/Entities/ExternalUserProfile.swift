//
//  ExternalUserProfile.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 05/10/26.
//

import Foundation

// G-07: response of GET and PATCH /internal-users/external-users/:userId
struct ExternalUserProfile: Identifiable, Decodable {
  let id: String
  let profile: PersonalData?
  let address: Address?

  enum CodingKeys: String, CodingKey {
    case id = "user_id"
    case profile
    case address
  }

  // Nested to avoid clashing with the Profile entity of pre-submission
  struct PersonalData: Decodable {
    let name: String?
    let lastName: String?
    let email: String?
    let birthDate: String?
    let phone: String?

    enum CodingKeys: String, CodingKey {
      case name
      case lastName = "last_name"
      case email
      case birthDate = "birth_date"
      case phone
    }
  }
}
