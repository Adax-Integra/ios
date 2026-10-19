//
//  EditCollaboratorUseCase.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 19/10/26.
//

import Foundation

protocol EditCollaboratorUseCaseProtocol {
  func editCollaborator(userId: String, request: EditCollaboratorRequest) async throws
}

class EditCollaboratorUseCase: EditCollaboratorUseCaseProtocol {
  let dataRepository: EditCollaboratorRepository

  init(dataRepository: EditCollaboratorRepository) {
    self.dataRepository = dataRepository
  }

  func editCollaborator(userId: String, request: EditCollaboratorRequest) async throws {
    try await dataRepository.editCollaborator(userId: userId, request: request)
  }
}
