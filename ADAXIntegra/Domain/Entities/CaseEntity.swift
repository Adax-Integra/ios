//
//  CaseEntity.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 23/09/26.
//

import Foundation

// Data an "externa" captures to register a new case (HU R-02)
struct CaseEntity: Equatable {
  let description: String
  let helpDetails: String
  let hasExternalSupport: Bool
}

// Character limits shared by the form fields. They mirror the backend validator
// (writtenDescription: 5000, writtenHelpsWanted: 400)
enum CaseFieldLimits {
  static let maxCharacters = 5000
  static let maxHelpDetailsCharacters = 400
}
