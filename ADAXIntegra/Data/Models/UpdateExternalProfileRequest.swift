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

  // The address only keeps the country, the state and the municipality
  struct AddressChanges: Encodable {
    let country: String?
    let state: String?
    let municipality: String?

    var isEmpty: Bool {
      country == nil && state == nil && municipality == nil
    }
  }
}
