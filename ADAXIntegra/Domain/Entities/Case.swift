//
//  Case.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 22/09/26.
//

import Foundation
import SwiftUI

enum CaseState: String {
  case inProgress = "in_progress"
  case closed = "closed"
  case pending = "pending"

  init(dbValue: String?) {
    switch dbValue?.trimmingCharacters(
      in:
        .whitespaces
    ).lowercased() {
    case "closed": self = .closed
    default: self = .inProgress
    }
  }

  var displayText: String {
    switch self {
    case .inProgress: return "En proceso"
    case .closed: return "Cerrado"
    case .pending: return "Pendiente"
    }
  }

  var indicatorColor: Color {
    switch self {
    case .inProgress: return .orange
    case .closed: return .green
    case .pending: return .red
    }
  }
}

struct Case: Identifiable, Codable {
  let id: String
  let caseNumber: String?
  let state: String?
  let urgency: String?
  let violenceTypes: [String]
  let updatedAt: String?

  enum CodingKeys: String, CodingKey {
    case id = "caseId"
    case caseNumber, state, urgency, violenceTypes, updatedAt
  }
}

extension Case {
  var updatedAtDate: Date? { Case.parse(updatedAt) }

  private static func parse(_ text: String?) -> Date? {
    guard let text else { return nil }
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return formatter.date(from: text)
  }
}
