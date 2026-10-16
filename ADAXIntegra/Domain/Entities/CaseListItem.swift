//
//  CaseListItem.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 24/09/26.
//
import Foundation

// reads keys by name so a field can come in snake_case or camelCase

private struct AnyKey: CodingKey {
  var stringValue: String
  var intValue: Int? { nil }
  init(stringValue: String) { self.stringValue = stringValue }
  init?(intValue: Int) { nil }
}

extension KeyedDecodingContainer where Key == AnyKey {
  // tries every possible name of a field
  fileprivate func value<T: Decodable>(_ type: T.Type, _ keys: [String]) -> T? {
    for key in keys {
      if let found = try? decodeIfPresent(type, forKey: AnyKey(stringValue: key)) {
        return found
      }
    }
    return nil
  }

  // text that can also come as a number
  fileprivate func text(_ keys: String...) -> String? {
    if let found = value(String.self, keys) { return found }
    if let found = value(Int.self, keys) { return String(found) }
    return nil
  }

  // number that can also come as text
  fileprivate func number(_ keys: String...) -> Int? {
    if let found = value(Int.self, keys) { return found }
    if let found = value(String.self, keys) { return Int(found) }
    return nil
  }
}

struct CaseListResult: Decodable {

  let cases: [CaseListItem]
  let total: Int
  let page: Int
  let limit: Int

  init(from decoder: Decoder) throws {
    // the list can come directly without an object
    if let list = try? decoder.singleValueContainer().decode([CaseListItem].self) {
      cases = list
      total = list.count
      page = 1
      limit = list.count
      return
    }

    let container = try decoder.container(keyedBy: AnyKey.self)

    let listKey = ["cases", "items", "rows", "data"]
      .map { AnyKey(stringValue: $0) }
      .first { container.contains($0) }

    if let listKey {
      cases = try container.decode([CaseListItem].self, forKey: listKey)
    } else {
      cases = []
    }

    // pagination can come at the top or inside another object
    let pagination = ["pagination", "meta"]
      .compactMap {
        try? container.nestedContainer(keyedBy: AnyKey.self, forKey: AnyKey(stringValue: $0))
      }
      .first

    total =
      container.number("total", "count") ?? pagination?.number("total", "count") ?? cases.count
    page = container.number("page") ?? pagination?.number("page") ?? 1
    limit = container.number("limit") ?? pagination?.number("limit") ?? cases.count
  }
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

    if let full = container.text("full_name", "fullName") {
      fullName = full
    } else {
      fullName = [container.text("name"), container.text("last_name", "lastName")]
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

    guard let caseId = container.text("case_id", "caseId", "id") else {
      throw DecodingError.keyNotFound(
        AnyKey(stringValue: "case_id"),
        .init(codingPath: decoder.codingPath, debugDescription: "Case without id")
      )
    }

    id = caseId
    caseNumber = container.text("case_number", "caseNumber", "number")
    name = container.text("name", "full_name", "fullName") ?? ""
    violenceTypes = container.value([String].self, ["violence_types", "violenceTypes"]) ?? []
    state = container.text("state", "status") ?? ""
    urgency = container.text("urgency") ?? "Sin evaluar"
    updatedAt = container.text("updated_at", "updatedAt")
    assignedNames =
      (container.value(
        [CaseAssignee].self,
        ["assigned_users", "assignedUsers", "assigned_to", "assignedTo"]
      ) ?? [])
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
