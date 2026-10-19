//
//  CaseRepository.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 22/09/26.
//
import Foundation

protocol CaseRepository {
  func getCases(for userId: String) async throws -> [Case]

  // R-02: returns the id of the created case, or nil if the request failed
  func createCase(_ newCase: NewCase, userId: String) async -> String?
  // R-11: creates a case for an external user from an internal account
  func createCaseForExternalUser(_ newCase: NewCase, userId: String) async throws -> String
  // V-11: case detail view and close-case action
  func getCaseDetail(caseId: String) async throws -> CaseDetail
  func closeCase(caseId: String) async throws -> Bool
  // R-10: accounts that can be assigned and the assignment itself
  func listAssignableCollaborators() async throws -> [AssignableCollaborator]
  func assignCollaborators(caseId: String, userIds: [String]) async throws -> Bool
  // R-13: updates steps on case
  func updateCaseStep(caseId: String, stepNumber: Int) async throws -> Bool
  // R-12: replaces the collaborators of the case, returns the ids that stay assigned
  func updateCollaborators(caseId: String, userIds: [String]) async throws -> [String]
}
