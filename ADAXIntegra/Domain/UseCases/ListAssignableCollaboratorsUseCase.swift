//
//  ListAssignableCollaboratorsUseCase.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 17/10/26.
//

import Foundation

protocol ListAssignableCollaboratorsUseCaseProtocol {
  func execute() async throws -> [AssignableCollaborator]
}

// R-10: the accounts an admin or internal user can assign to a case
struct ListAssignableCollaboratorsUseCase: ListAssignableCollaboratorsUseCaseProtocol {
  let repository: CaseRepository

  init(repository: CaseRepository = RemoteCaseRepository()) {
    self.repository = repository
  }

  func execute() async throws -> [AssignableCollaborator] {
    try await repository.listAssignableCollaborators()
  }
}
