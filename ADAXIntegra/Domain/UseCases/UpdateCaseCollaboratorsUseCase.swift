//
//  UpdateCaseCollaboratorsUseCase.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 19/10/26.
//

import Foundation

protocol UpdateCaseCollaboratorsUseCaseProtocol {
  func execute(caseId: String, userIds: [String]) async throws -> [String]
}

// R-12: an admin or internal user sends the final list of collaborators of a case
struct UpdateCaseCollaboratorsUseCase: UpdateCaseCollaboratorsUseCaseProtocol {
  let repository: CaseRepository

  init(repository: CaseRepository = RemoteCaseRepository()) {
    self.repository = repository
  }

  func execute(caseId: String, userIds: [String]) async throws -> [String] {
    try await repository.updateCollaborators(caseId: caseId, userIds: userIds)
  }
}
