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

// reads keys by name so a field can come in snake_case or camelCase

private struct AnyKey: CodingKey {
  var stringValue: String
  var intValue: Int? { nil }
  init(stringValue: String) { self.stringValue = stringValue }
  init?(intValue: Int) { nil }
}

// collaborator assigned to a case, can come as text or as an object

private struct CaseAssignee: Decodable {
  let fullName: String

  init(from decoder: Decoder) throws {
    // plain text
    if let text = try? decoder.singleValueContainer().decode(String.self) {
      fullName = text
      return
    }

    // object with name and last name
    let container = try decoder.container(keyedBy: AnyKey.self)
    func text(_ keys: String...) -> String? {
      for key in keys {
        if let value = try? container.decodeIfPresent(String.self, forKey: AnyKey(stringValue: key))
        {
          return value
        }
      }
      return nil
    }

    if let full = text("full_name", "fullName") {
      fullName = full
    } else {
      fullName = [text("name"), text("last_name", "lastName")]
        .compactMap { $0?.trimmingCharacters(in: .whitespaces) }
        .filter { !$0.isEmpty }
        .joined(separator: " ")
    }
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
  let assignedNames: [String]

  // only the id is required, the rest shows "-" if it is missing
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: AnyKey.self)

    // tries every possible name of a field
    func value<T: Decodable>(_ type: T.Type, _ keys: String...) -> T? {
      for key in keys {
        if let found = try? container.decodeIfPresent(type, forKey: AnyKey(stringValue: key)) {
          return found
        }
      }
      return nil
    }

    guard let caseId = value(String.self, "case_id", "caseId", "id") else {
      throw DecodingError.keyNotFound(
        AnyKey(stringValue: "case_id"),
        .init(codingPath: decoder.codingPath, debugDescription: "Case without id")
      )
    }

    id = caseId
    caseNumber = value(String.self, "case_number", "caseNumber", "number")
    name = value(String.self, "name", "full_name", "fullName") ?? ""
    violenceTypes = value([String].self, "violence_types", "violenceTypes") ?? []
    state = value(String.self, "state", "status") ?? ""
    urgency = value(String.self, "urgency") ?? "Sin evaluar"
    updatedAt = value(String.self, "updated_at", "updatedAt")
    assignedNames =
      (value([CaseAssignee].self, "assigned_users", "assignedUsers", "assigned_to", "assignedTo")
      ?? [])
      .map(\.fullName)
      .filter { !$0.isEmpty }
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
