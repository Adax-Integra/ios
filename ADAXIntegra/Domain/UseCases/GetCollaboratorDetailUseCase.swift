//
//  GetCollaboratorDetailUseCase.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 17/10/26.
//

import Foundation

// Protocol for retrieving the detail of a collaborator
protocol GetCollaboratorDetailUseCaseProtocol {
  func getCollaboratorDetail(for userId: String) async throws -> CollaboratorDetail
}

// The use case only asks the repository for the data
class GetCollaboratorDetailUseCase: GetCollaboratorDetailUseCaseProtocol {
  let dataRepository: CollaboratorDetailRepository

  init(dataRepository: CollaboratorDetailRepository) {
    self.dataRepository = dataRepository
  }

  func getCollaboratorDetail(for userId: String) async throws -> CollaboratorDetail {
    try await dataRepository.fetchDetail(userId: userId)
  }
}
