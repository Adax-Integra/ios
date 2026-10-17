//
//  ListHelpTypesUseCase.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 16/10/26.
//

import Foundation

protocol ListHelpTypesUseCaseProtocol {
  func execute() async throws -> [HelpType]
}

struct ListHelpTypesUseCase: ListHelpTypesUseCaseProtocol {
  let dataRepository: CaseHelpRepository

  init(dataRepository: CaseHelpRepository = RemoteCaseHelpRepository()) {
    self.dataRepository = dataRepository
  }

  // stored by name so the list always shows in the same order

  func execute() async throws -> [HelpType] {
    try await dataRepository.listHelpTypes()
      .sorted { $0.title.localizedCompare($1.title) == .orderedAscending }
  }
}
