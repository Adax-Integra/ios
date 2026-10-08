//
//  RecordDetails.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 04/10/26.
//

import Foundation

struct RecordDetails: Identifiable, Codable {
  let id: String
  // Backend DTO sends null for these when they are empty
  let writtenDescription: String?
  let writtenHelpsWanted: String?
  let hasLawyer: Bool
  let state: String?  // State as in status
  let createdAt: String
  let updatedAt: String
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
    Date.extractDate(createdAt)
  }

  var createdTimeString: String {
    Date.extractTime(createdAt)
  }

  var updatedDateString: String {
    Date.extractDate(updatedAt)
  }

  var updatedTimeString: String {
    Date.extractTime(updatedAt)
  }

  // Backend sends each help with a "\n" at the end
  var cleanHelps: [String] {
    helps.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
  }
}
