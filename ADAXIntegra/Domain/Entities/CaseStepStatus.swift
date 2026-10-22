//
//  CaseStepStatus.swift
//  ADAXIntegra
//
//  Created by Lakshmi Jara on 15/10/26.
//

import Foundation

enum CaseStepStatus {
  case completed
  case inProgress
  case pending
  case unknown

  // normalizes capitalization and surrounding whitespace from the API
  init(rawValue: String?) {
    let value = rawValue?
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .lowercased()

    switch value {
    case "completado":
      self = .completed
    case "en progreso":
      self = .inProgress
    case "pendiente":
      self = .pending
    default:
      self = .unknown
    }
  }

  var displayText: String {
    switch self {
    case .completed:
      return "Completado"
    case .inProgress:
      return "En progreso"
    case .pending:
      return "Pendiente"
    case .unknown:
      return "Estado no disponible"
    }
  }
}
