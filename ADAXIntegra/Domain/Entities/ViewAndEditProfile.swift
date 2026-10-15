//
//  ViewAndEditProfile.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 15/10/26.
//

import Foundation

struct ProfileStaff: Identifiable, Codable {
  let id: String
  let name: String
  let lastName: String
  let phone: String

  enum CodingKeys: String, CodingKey {
    case id = "user_id"
    case name
    case lastName = "last_name"
    case phone
  }
}

struct ProfileExternal: Identifiable, Codable {
  let id: String
  let name: String
  let lastName: String
  let phone: String
  let address: AddressProfile?

  enum CodingKeys: String, CodingKey {
    case id = "user_id"
    case name
    case lastName = "last_name"
    case phone
    case address
  }
}

struct UpdateProfileRequest: Encodable {
  var name: String?
  var lastName: String?
  var phone: String?
  var country: String?
  var state: String?
  var municipality: String?

  enum CodingKeys: String, CodingKey {
    case name
    case lastName = "last_name"
    case phone
    case country
    case state
    case municipality
  }

  // Skip the request if there are no fields
  var isEmpty: Bool {
    [name, lastName, phone, country, state, municipality].allSatisfy { $0 == nil }
  }
}

struct AddressProfile: Codable {
  let country: String?
  let state: String?
  let municipality: String?
}
