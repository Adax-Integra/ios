//
//  RemoteCaseHelpRepository.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 16/10/26.
//
import Foundation

struct RemoteCaseHelpRepository: CaseHelpRepository {
  // catalog of help types
  func listHelpTypes() async throws -> [HelpType] {
    let response = try await APIProtocol.get(
      "/help-types",
      as: APIResponse<[HelpType]>.self
    )
    return response.data
  }

  // sends the final list, an empty list removes every help of the case
  func assignHelps(caseId: String, helpIds: [String]) async throws -> CaseHelpsAssignment {
    let response = try await APIProtocol.put(
      "/cases/\(caseId)/helps",
      body: AssignCaseHelpsRequest(helpIds: helpIds),
      as: APIResponse<CaseHelpsAssignment>.self
    )
    return response.data
  }
}
