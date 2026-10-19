//
//  ListActivityLogUseCase.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 18/10/26.
//

import Foundation

protocol ListActivityLogUseCaseProtocol {
  func listActivityLog(page: Int, from: Date?, to: Date?) async throws -> ActivityLogResult
}

class ListActivityLogUseCase: ListActivityLogUseCaseProtocol {
  let dataRepository: ActivityLogRepository

  // Uses the remote repository by default so the viewmodel can create it without arguments
  init(dataRepository: ActivityLogRepository = RemoteActivityLogRepository()) {
    self.dataRepository = dataRepository
  }

  func listActivityLog(page: Int, from: Date?, to: Date?) async throws -> ActivityLogResult {
    // The backend rejects invalid range
    if let from, let to, from > to {
      throw URLError(.badURL)
    }
    return try await dataRepository.listActivityLog(page: page, from: from, to: to)
  }
}
