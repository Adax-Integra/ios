//
//  CreateAccountUseCase.swift
//
//
//  Created by Lakshmi Jara on 24/09/26.
//
// G-01

// passes the registration data to the repository and returns the created account to the ViewModel

final class CreateAccountUseCase {
  private let repository: CreateAccountRepositoryP

  init(repository: CreateAccountRepositoryP) {
    self.repository = repository
  }

  // recives the form data and waits for the repository's response
  // returns the account information or passes the error to the ViewModel
  func execute(input: CreateAccountInput) async throws -> CreateAccountEntity {
    try await repository.createAccount(input: input)
  }
}
