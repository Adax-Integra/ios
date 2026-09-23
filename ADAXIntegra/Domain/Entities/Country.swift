//
//  Country.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 22/09/26.
//

import Foundation

// Reference entity representing a country the app supports for address /
// identification data. "states" contains the country's first-level
// administrative divisions (estados), in Spanish, alphabetically sorted.
struct Country: Identifiable, Hashable, Codable {
  // ISO 3166-1 alpha-2 code (e.g. "MX", "US").
  let isoCode: String

  // Spanish display name (e.g. "México", "Estados Unidos de América")
  let name: String

  // E.164 dial code with leading "+" (e.g. "+52", "+1")
  let dialCode: String

  let states: [String]

  var id: String { isoCode }

  // Method to find the country with the given name in the list of countries.
  static func first(named name: String, in list: [Country] = Country.all) -> Country? {
    list.first { $0.name == name }
  }

  // List of dial codes for phone-country dropdowns. Duplicates
  // are collapsed (e.g. "+1" for both US and Canada)
  static var allDialCodes: [String] {
    var seen = Set<String>()
    return all.compactMap { seen.insert($0.dialCode).inserted ? $0.dialCode : nil }
  }
}
