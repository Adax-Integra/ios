//
//  CollaboratorStatus.swift
//  ADAXIntegra
//
//  Created by Laura Cintora on 17/10/26.
//

import Foundation

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
