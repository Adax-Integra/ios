//
//  Country.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 22/09/26.
//

import Foundation

struct Country: Identifiable, Codable {
  let id: String
  let iso2: String
  let nameEn: String
  let nameEs: String
  let phoneCode: String
  let states: [CountryState]

  enum CodingKeys: String, CodingKey {
    case id = "country_id"
    case iso2
    case nameEn = "name_en"
    case nameEs = "name_es"
    case phoneCode = "phone_code"
    case states
  }

  /*
   Convert country's own states into a list of options for the
   state dropdown
  */
  var stateNames: [String] {
    states.map(\.nameEs)
  }

  // Returns the first country matching the country in spanish
  static func first(name: String, in list: [Country]) -> Country? {
    list.first { $0.nameEs == name }
  }

  // Builds a list of countries' phone codes for the dropdown buttons
  static func dialCodes(in list: [Country]) -> [String] {
    // Create a set to hold each value we give it only once
    var seen = Set<String>()
    // Builds a new array based on the iteration of seen
    return list.compactMap { seen.insert($0.phoneCode).inserted ? $0.phoneCode : nil }
  }
}

struct CountryState: Identifiable, Codable {
  let id: String
  let nameEn: String
  let nameEs: String
  let code: String

  enum CodingKeys: String, CodingKey {
    case id = "state_id"
    case nameEn = "name_en"
    case nameEs = "name_es"
    case code
  }

}
