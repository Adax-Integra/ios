//
//  CollaboratorAssignedCase.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 17/10/26.
//

import Foundation

// card for the cases tab of the detail of a collaborator of us G-10
struct CollaboratorAssignedCase: Decodable, Identifiable, Equatable {
  let id: String
  let caseNumber: String?
  // Full name of the external whose record is (nombre de la externa a quien pertenece el caso, no supe ponerlo en inglés)
  let name: String
  let violenceTypes: [String]
  // Value stored in the database "Open" or "Closed"
  let state: String?
  // Timestamp with only date
  let updatedAt: String?

  enum CodingKeys: String, CodingKey {
    case id = "case_id"
    case caseNumber = "case_number"
    case name
    case violenceTypes = "violence_types"
    case state
    case updatedAt = "updated_at"
  }
}

// Body of GET /internal-users/{userId}/assigned-cases 
struct CollaboratorAssignedCases: Decodable, Equatable {
  let cases: [CollaboratorAssignedCase]
  // Number of cases returned
  let total: Int
}
