//
//  AssignCaseCollaboratorUseCase.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 17/10/26.
//

import Foundation

protocol AssignCaseCollaboratorUseCaseProtocol {
  func execute(caseId: String, userIds: [String]) async throws -> Bool
}

// R-10: an admin or internal user assigns one or more internal or admin users to a case
struct AssignCaseCollaboratorUseCase: AssignCaseCollaboratorUseCaseProtocol {
  let repository: CaseRepository

  init(repository: CaseRepository = RemoteCaseRepository()) {
    self.repository = repository
  }

  func execute(caseId: String, userIds: [String]) async throws -> Bool {
    try await repository.assignCollaborators(caseId: caseId, userIds: userIds)
  }
}
