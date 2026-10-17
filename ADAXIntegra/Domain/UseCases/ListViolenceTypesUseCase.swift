//
//  ListViolenceTypesUseCase.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 17/10/26.
//

import Foundation

protocol ListViolenceTypesUseCaseProtocol {
  func execute() async throws -> [ViolenceType]
}

struct ListViolenceTypesUseCase: ListViolenceTypesUseCaseProtocol {
  let dataRepository: CaseViolenceRepository

  init(dataRepository: CaseViolenceRepository = RemoteCaseViolenceRepository()) {
    self.dataRepository = dataRepository
  }

  // sorted by name so the list always shows in the same order

  func execute() async throws -> [ViolenceType] {
    try await dataRepository.listViolenceTypes()
      .sorted { $0.title.localizedCompare($1.title) == .orderedAscending }
  }
}
