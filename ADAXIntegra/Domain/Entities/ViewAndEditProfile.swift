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

struct AddressProfile: Codable {
  let country: String?
  let state: String?
  let municipality: String?
}
