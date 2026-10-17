//
//  AssignCaseHelpsUseCase.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 16/10/26.
//

import Foundation

protocol AssignCaseHelpsUseCaseProtocol {
  func execute(caseId: String, helpIds: [String]) async throws -> CaseHelpsAssignment
}

struct AssignCaseHelpsUseCase: AssignCaseHelpsUseCaseProtocol {
  let dataRepository: CaseHelpRepository

  init(dataRepository: CaseHelpRepository = RemoteCaseHelpRepository()) {
    self.dataRepository = dataRepository
  }

  // the backend will reject the duplicated ids so they are removed before sending

  func execute(caseId: String, helpIds: [String]) async throws -> CaseHelpsAssignment {
    let uniqueIds = Array(Set(helpIds.map { $0.lowercased() }))
    return try await dataRepository.assignHelps(caseId: caseId, helpIds: uniqueIds)
  }
}
