//
//  GetCollaboratorAssignedCasesUseCase.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 17/10/26.
//


import Foundation

// Protocol for retrieving the cases assigned to a collaborator
protocol GetCollaboratorAssignedCasesUseCaseProtocol {
  func getAssignedCases(for userId: String) async throws -> CollaboratorAssignedCases
}

class GetCollaboratorAssignedCasesUseCase: GetCollaboratorAssignedCasesUseCaseProtocol {
  let dataRepository: CollaboratorDetailRepository

  init(dataRepository: CollaboratorDetailRepository) {
    self.dataRepository = dataRepository
  }

  func getAssignedCases(for userId: String) async throws -> CollaboratorAssignedCases {
    try await dataRepository.fetchAssignedCases(userId: userId)
  }
}
