//
//  ListCollaboratorsUseCase.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 10/10/26.
//

import Foundation

protocol ListCollaboratorsUseCaseProtocol {
  func listCollaborators() async throws -> [CollaboratorListItem]
}

// G-06: the admin consults the collaborator accounts
class ListCollaboratorsUseCase: ListCollaboratorsUseCaseProtocol {
  let dataRepository: CollaboratorRepository

  init(dataRepository: CollaboratorRepository) {
    self.dataRepository = dataRepository
  }

  func listCollaborators() async throws -> [CollaboratorListItem] {
    try await dataRepository.listCollaborators()
  }
}
