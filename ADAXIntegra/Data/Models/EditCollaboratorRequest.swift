//
//  EditCollaboratorRequest.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 19/10/26.
//

import Foundation

// G-11 model for a  PATCH with the route  /internal-users/:userId
// Optional fields that are nil are not encoded, so only the changed fields are sent
struct EditCollaboratorRequest: Encodable {
  struct Profile: Encodable {
    let name: String?
    let lastName: String?
    let email: String?
    let phone: String?

    enum CodingKeys: String, CodingKey {
      case name
      case lastName = "last_name"
      case email
      case phone
    }
  }

  let profile: Profile
}
