//
//  CloseCaseUseCase.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 02/10/26.
//
// USecase closes a case backend enforces that it can
//  only be closed once (atomic update), so no extra validation is needed here :) thnks me from backend
//

import Foundation
// Executes the action to close a specific case, we use the caseId because we need the UUID of the case and in return we give a boolean that tells wether the was succesfully closed
  
protocol CloseCaseUseCaseProtocol {
  func execute(caseId: String) async throws -> Bool
}

class CloseCaseUseCase: CloseCaseUseCaseProtocol {
  let repository: CaseRepository

  init(repository: CaseRepository) {
    self.repository = repository
  }
    //Returns true if the backend successfully closes the case, or throws an error if it fails
  func execute(caseId: String) async throws -> Bool {
    try await repository.closeCase(caseId: caseId)
  }
}
