//
//  ListExternalUsersUseCase.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 16/10/26.
//

import Foundation

protocol ListExternalUsersUseCaseProtocol {
  func listExternalUsers(
    page: Int,
    search: String,
    status: String,
    sort: String
  ) async throws -> ExternalUserListResult
}

// G-16: the admin consults the external accounts
class ListExternalUsersUseCase: ListExternalUsersUseCaseProtocol {
  let dataRepository: ExternalUserListRepository

  init(dataRepository: ExternalUserListRepository) {
    self.dataRepository = dataRepository
  }

  func listExternalUsers(
    page: Int,
    search: String,
    status: String,
    sort: String
  ) async throws -> ExternalUserListResult {
    try await dataRepository.listExternalUsers(
      page: page, search: search, status: status, sort: sort)
  }
}
