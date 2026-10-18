//
//  CollaboratorStatus.swift
//  ADAXIntegra
//
//  Created by Laura Cintora on 17/10/26.
//

import Foundation

// G-04: body the app sends to the backend to change the status
// It becomes: { "is_active": true } (activate) or { "is_active": false } (deactivate)
struct UpdateCollaboratorStatusRequest: Encodable {
  let isActive: Bool
  // The new status: true = active, false = inactive
  enum CodingKeys: String, CodingKey {
    case isActive = "is_active"
  }
}

// G-04: response the backend sends back when the change worked.
struct CollaboratorStatusResult: Decodable {
  // Id of the collaborator whose status changed
  let id: String
  // Status that was saved: true = active, false = inactive
  let isActive: Bool

  enum CodingKeys: String, CodingKey {
    case id = "user_id"
    case isActive = "is_active"
  }
}
