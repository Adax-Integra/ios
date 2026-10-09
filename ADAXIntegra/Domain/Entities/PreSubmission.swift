//
//  PreSubmission.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 01/10/26.
//

import Foundation

struct PreSubmission: Identifiable, Codable {
  let id: String
  let profile: Profile?
  let address: Address?
  let documents: Documents?

  enum CodingKeys: String, CodingKey {
    case id = "user_id"
    case profile
    case address
    case documents
  }
}

struct Profile: Codable {
  let name: String?
  let lastName: String?
  let birthDate: String?
  let phone: String?

  enum CodingKeys: String, CodingKey {
    case name
    case lastName = "last_name"
    case birthDate = "birth_date"
    case phone
  }

  var birthDateValue: Date? {
    /*
     flatMap runs a function on an optional value,
     if the value isn't there, skip the function.
    */
    birthDate.flatMap(Date.parseBirthDate)
  }
}

struct Address: Codable {
  let addressLine1: String?
  let addressLine2: String?
  let neighborhood: String?
  let zipCode: String?
  let country: String?
  let state: String?
  let city: String?

  enum CodingKeys: String, CodingKey {
    case addressLine1 = "address_line_1"
    case addressLine2 = "address_line_2"
    case neighborhood
    case zipCode = "zip_code"
    case country
    case state
    case city
  }
}

struct Documents: Identifiable, Codable {
  let id: String?
  let identityDocumentUrl: String?
  let proofOfAddressUrl: String?

  enum CodingKeys: String, CodingKey {
    case id = "document_id"
    case identityDocumentUrl = "identity_document_url"
    case proofOfAddressUrl = "proof_of_address_url"
  }
}
