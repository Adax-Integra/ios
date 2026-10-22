//
//  CaseViolenceRepository.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 17/10/26.
//

import Foundation

protocol CaseViolenceRepository {
  func listViolenceTypes() async throws -> [ViolenceType]
  func assignViolenceTypes(caseId: String, violenceIds: [String]) async throws
    -> ViolenceTypesAssignment
}
