//
//  CreateAccountUseCase.swift
//
//
//  Created by Lakshmi Jara on 24/09/26.
//
// G-01

final class CreateAccountUseCase {
  private let repository: CreateAccountRepositoryP

  init(repository: CreateAccountRepositoryP) {
    self.repository = repository
  }

  // sends the form data to the repository
  func execute(input: CreateAccountInput) async throws -> CreateAccountEntity {
    try await repository.createAccount(input: input)
  }
}
