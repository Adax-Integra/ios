//
//  UpdateExternalProfileRequest.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 05/10/26.
//

import Foundation

//Body of PATCH /internal-users/external-users/:userId (G-07)
//Only the fields that changed are filled, nil values are left out of the JSON
struct UpdateExternalProfileRequest: Encodable {
  let profile: ProfileChanges?
  let address: AddressChanges?
  let reason: String
  let consentConfirmed: Bool

  struct ProfileChanges: Encodable {
    let email: String?
    let phone: String?

    var isEmpty: Bool { email == nil && phone == nil }
  }

  struct AddressChanges: Encodable {
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

    var isEmpty: Bool {
      [addressLine1, addressLine2, neighborhood, zipCode, country, state, city].allSatisfy {
        $0 == nil
      }
    }
  }
}
