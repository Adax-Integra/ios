//
//  RecordDetails.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 04/10/26.
//

import Foundation

struct RecordDetails: Identifiable, Codable {
  let id: String
  let caseNumber: String?
  let state: String
  let userName: String
  let violenceTypes: [String]
  let assignedUsers: [AssignedUser]
  let urgency: String
  let updatedAt: String

  enum CodingKeys: String, CodingKey {
    case id = "caseId"
    case caseNumber
    case state
    case userName
    case violenceTypes
    case assignedUsers
    case urgency
    case updatedAt
  }

  var urgencyType: UrgencyType? {
    // Backend sends "Alta" / "Media" / "Baja" / "Sin evaluar"
    UrgencyType(rawValue: urgency.lowercased())
  }

  // Falls back to a shortened caseId when the backend doesn't send a caseNumber
  var displayCaseNumber: String {
    if let caseNumber, !caseNumber.isEmpty {
      return caseNumber
    }
    return String(id.prefix(8))
  }

  var updatedDateString: String {
    Date.extractDate(updatedAt)
  }
}

// Internal user assigned to a case
struct AssignedUser: Codable {
  let userId: String
  let name: String
}
