//
//  ViolenceType.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 17/10/26.
//

import Foundation

// violence type of the catalog that an internal can assign to a case

struct ViolenceType: Decodable, Identifiable, Equatable {
  let violenceId: String
  let description: String?
  let severity: Int?

  var id: String { violenceId }

  // name shown on the checkbox
  var title: String {
    guard let description, !description.isEmpty else { return "-" }
    return description
  }
}

// the full list of selected violence types

struct AssignViolenceTypesRequest: Encodable {
  let violenceIds: [String]
}

// violence types of the case after saving with the urgency calculated by the backend

struct ViolenceTypesAssignment: Decodable {
  let caseId: String
  let violenceIds: [String]
  let urgency: String
}

// same rule as the backend the most severe violence type decides the urgency

enum CaseUrgency {
  static func from(severity: Int?) -> String {
    guard let severity, severity >= 1 else { return "Sin evaluar" }
    if severity >= 8 { return "Alta" }
    if severity >= 4 { return "Media" }
    return "Baja"
  }
}
