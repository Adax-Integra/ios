//
//  HelpType.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 16/10/26.
//

import Foundation

// help type of the catalog that an internal can assign to a case

struct HelpType: Decodable, Identifiable, Equatable {
  let helpId: String
  let description: String?

  var id: String { helpId }

  // name shown on the checkbox
  var title: String {
    guard let description, !description.isEmpty else { return "-" }
    return description
  }
}

// body of the full list of selected helps

struct AssignCaseHelpsRequest: Encodable {
  let helpIds: [String]
}

// helps of the case after saving

struct CaseHelpsAssignment: Decodable {
  let caseId: String
  let helps: [HelpType]
}
