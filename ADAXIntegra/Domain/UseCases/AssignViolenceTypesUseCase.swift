//
//  AssignViolenceTypesUseCase.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 17/10/26.
//

import Foundation

protocol AssignViolenceTypesUseCaseProtocol {
  func execute(caseId: String, violenceIds: [String]) async throws -> ViolenceTypesAssignment
}

struct AssignViolenceTypesUseCase: AssignViolenceTypesUseCaseProtocol {
  let dataRepository: CaseViolenceRepository

  init(dataRepository: CaseViolenceRepository = RemoteCaseViolenceRepository()) {
    self.dataRepository = dataRepository
  }

  // the backend will reject dupicated ids so there are removed before sending

  func execute(caseId: String, violenceIds: [String]) async throws -> ViolenceTypesAssignment {
    let uniqueIds = Array(Set(violenceIds.map { $0.lowercased() }))
    return try await dataRepository.assignViolenceTypes(caseId: caseId, violenceIds: uniqueIds)
  }
}
