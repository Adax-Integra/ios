//
//  CaseAssignment.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 17/10/26.
//

import Foundation

// R-10: the backend only sends active internal and admin accounts
struct AssignableCollaborator: Identifiable, Decodable {
  let id: String
  let name: String?
  let lastName: String?

  enum CodingKeys: String, CodingKey {
    case id = "userId"
    case name
    case lastName
  }

  var fullName: String {
    let text = "\(name ?? "") \(lastName ?? "")".trimmingCharacters(in: .whitespaces)
    return text.isEmpty ? "Sin nombre" : text
  }

  var initials: String {
    let first = name?.first.map(String.init) ?? ""
    let second = lastName?.first.map(String.init) ?? ""
    return (first + second).uppercased()
  }
}

// R-10 and R-12 send the same body
struct AssignCaseCollaboratorsRequest: Encodable {
  let userIds: [String]
}

struct CaseAssignmentResult: Decodable {
  let success: Bool
}

// R-12: the collaborators that stay assigned after the update
struct UpdatedCaseCollaborators: Decodable {
  let caseId: String
  let userIds: [String]
}
