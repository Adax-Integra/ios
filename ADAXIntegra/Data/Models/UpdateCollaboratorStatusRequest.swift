//
//  UpdateCollaboratorStatusRequest.swift
//  ADAXIntegra
//
//  Created by Laura Cintora on 17/10/26.
//

import Foundation

// Body of PATCH /internal-users/{userId}/status (G-04)
// It becomes: { "is_active": true } (activate) or { "is_active": false } (deactivate)
struct UpdateCollaboratorStatusRequest: Encodable {
  // The new status: true = active, false = inactive
  let isActive: Bool

  enum CodingKeys: String, CodingKey {
    case isActive = "is_active"
  }
}
