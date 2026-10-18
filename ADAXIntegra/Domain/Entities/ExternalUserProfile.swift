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
  let verificationStatus: String?
  let profile: PersonalData?
  let address: AddressData?

  enum CodingKeys: String, CodingKey {
    case id = "user_id"
    case verificationStatus = "verification_status"
    case profile
    case address
  }
    
  var verification: VerificationStatus {
      VerificationStatus(rawValue: verificationStatus ?? "") ?? .noVerificado
        
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
  // The address only keeps the country, the state and the municipality
  struct AddressData: Decodable {
    let country: String?
    let state: String?
    let municipality: String?
  }
}
