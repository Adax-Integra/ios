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
  let updatedAt: String

  enum CodingKeys: String, CodingKey {
    case id = "caseId"
    case caseNumber
    case state
    case userName
    case violenceTypes
    case assignedUsers
    case updatedAt
  }

  var status: CaseStatus? {
    CaseStatus(rawValue: state)
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
