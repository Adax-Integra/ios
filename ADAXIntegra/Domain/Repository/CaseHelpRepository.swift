//
//  CaseHelpRepository.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 16/10/26.
//

import Foundation

protocol CaseHelpRepository {
  func listHelpTypes() async throws -> [HelpType]
  func assignHelps(caseId: String, helpIds: [String]) async throws -> CaseHelpsAssignment
}
