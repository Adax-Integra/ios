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
  let createdAt: Date
  let updatedAt: Date
  let helps: [String]
  let violenceTypes: [String]

  enum CodingKeys: String, CodingKey {
    case id = "caseId"
    case writtenDescription
    case writtenHelpsWanted
    case hasLawyer
    case createdAt
    case updatedAt
    case helps
    case violenceTypes
  }
}
