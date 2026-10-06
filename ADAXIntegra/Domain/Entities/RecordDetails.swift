//
//  RecordDetails.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 04/10/26.
//

import Foundation

struct RecordDetails: Identifiable, Codable {
  let id: String
  let writtenDescription: String
  let writtenHelpsWanted: String
  let hasLawyer: Bool
  let state: String  // State as in status
  let createdAt: Date
  let updatedAt: Date
  let helps: [String]
  let violenceTypes: [String]

  enum CodingKeys: String, CodingKey {
    case id = "caseId"
    case writtenDescription
    case writtenHelpsWanted
    case hasLawyer
    case state
    case createdAt
    case updatedAt
    case helps
    case violenceTypes
  }

  var createdDateString: String {
    createdAt.dateString
  }

  var createdTimeString: String {
    createdAt.timeString
  }

  var updatedDateString: String {
    updatedAt.dateString
  }

  var updatedTimeString: String {
    updatedAt.timeString
  }

  // Backend sends each help with a "\n" at the end
  var cleanHelps: [String] {
    helps.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
  }
}
