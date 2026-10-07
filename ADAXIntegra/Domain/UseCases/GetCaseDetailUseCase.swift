//
//  GetCaseDetailUseCase.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 02/10/26.
//
//  Usecase for US v-11 that fetches the full detail of a single case
//

import Foundation

protocol GetCaseDetailUseCaseProtocol {
  // Fetches full details for a particular  case where we recieve  caseId
  // and returns CaseDetail instance with the xase data
  func execute(caseId: String) async throws -> CaseDetail
}
//Handles the business logic for retrieving case details by delegating the call to the repository
class GetCaseDetailUseCase: GetCaseDetailUseCaseProtocol {
  let repository: CaseRepository
  // Initializes the use case with a case repository dependency we use the repository instance that performs data operations
  init(repository: CaseRepository) {
    self.repository = repository
  }

  // Asynchronously requests the full case details for the specified UUID and returns
  // a full CaseDetail object or throws an error if retrieval fails
  func execute(caseId: String) async throws -> CaseDetail {
    try await repository.getCaseDetail(caseId: caseId)
  }
}
