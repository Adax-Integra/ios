//
//  ListAssignedCasesUseCase.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 17/10/26.
//

import Foundation

protocol ListAssignedCasesUseCaseProtocol {
  func execute(page: Int, limit: Int, search: String, urgency: String) async throws
    -> CaseListResult
}

// V-12: the collaborator consults the cases she is working on
class ListAssignedCasesUseCase: ListAssignedCasesUseCaseProtocol {
  let repository: CaseListRepository

  init(repository: CaseListRepository) {
    self.repository = repository
  }

  func execute(page: Int, limit: Int, search: String, urgency: String) async throws
    -> CaseListResult
  {
    try await repository.listAssignedCases(
      page: page, limit: limit, search: search, urgency: urgency)
  }
}
