//
//  CaseListItem.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 24/09/26.
//
import Foundation

struct CaseListResult: Decodable {

  let cases: [CaseListItem]
  let total: Int
  let page: Int
  let limit: Int

}

// Collaborator assigned to a case

struct CaseAssignee: Decodable {
  let name: String?
  let lastName: String?

  enum CodingKeys: String, CodingKey {
    case name
    case lastName = "last_name"
  }

  var fullName: String {
    [name, lastName]
      .compactMap { $0?.trimmingCharacters(in: .whitespaces) }
      .filter { !$0.isEmpty }
      .joined(separator: " ")
  }
}

struct CaseListItem: Identifiable, Decodable {
  let id: String
  let caseNumber: String?
  let name: String
  let violenceTypes: [String]
  let state: String
  let urgency: String
  let updatedAt: String?
  let assignedUsers: [CaseAssignee]

  enum CodingKeys: String, CodingKey {
    case id = "case_id"
    case caseNumber = "case_number"
    case name
    case violenceTypes = "violence_types"
    case state
    case urgency
    case updatedAt = "updated_at"
    case assignedUsers = "assigned_users"
  }

  // The new fields are optional, so the list still loads if the backend does not send them
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(String.self, forKey: .id)
    caseNumber = try container.decodeIfPresent(String.self, forKey: .caseNumber)
    name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
    violenceTypes = try container.decodeIfPresent([String].self, forKey: .violenceTypes) ?? []
    state = try container.decodeIfPresent(String.self, forKey: .state) ?? ""
    urgency = try container.decodeIfPresent(String.self, forKey: .urgency) ?? "Sin evaluar"
    updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
    assignedUsers = try container.decodeIfPresent([CaseAssignee].self, forKey: .assignedUsers) ?? []
  }
}

extension CaseListItem {
  var displayName: String {
    name.isEmpty ? "Sin nombre" : name
  }

  // number shown on card
  var displayCaseNumber: String {
    guard let caseNumber, !caseNumber.isEmpty else { return "-" }
    return caseNumber
  }

  // names of the collaborators involved in the case
  var assignedNames: [String] {
    assignedUsers.map(\.fullName).filter { !$0.isEmpty }
  }

  var stateText: String {
    switch state {
    case "Open": return "En proceso"
    case "Closed": return "Completado"
    default: return state
    }
  }

  var updatedDate: Date? {
    guard let updatedAt, updatedAt.count >= 19 else { return nil }
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(identifier: "UTC")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    return formatter.date(from: String(updatedAt.prefix(19)))

  }
}
