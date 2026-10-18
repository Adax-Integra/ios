//
//  UpdateCollaboratorStatusUseCase.swift
//  ADAXIntegra
//
//  Created by Laura Cintora on 17/10/26
//

import Foundation

protocol UpdateCollaboratorStatusUseCaseProtocol {
  func updateStatus(userId: String, isActive: Bool) async throws -> CollaboratorStatusResult
}

// G-04: the admin turns a collaborator account on or off
class UpdateCollaboratorStatusUseCase: UpdateCollaboratorStatusUseCaseProtocol {
  let dataRepository: CollaboratorDetailRepository

  // Gets the repository when it is created
  init(dataRepository: CollaboratorDetailRepository) {
    self.dataRepository = dataRepository
  }

  // Gets who (userId) and the new status (isActive)
  func updateStatus(userId: String, isActive: Bool) async throws -> CollaboratorStatusResult {
    try await dataRepository.updateStatus(userId: userId, isActive: isActive)
  }
}
