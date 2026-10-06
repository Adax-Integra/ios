//
//  CreateAccountUseCase.swift
//
//
//  Created by Lakshmi Jara on 24/09/26.
//
// G-01

// passes the registration data to the repository and returns the created account to the ViewModel

struct CreateAccountUseCase {
  private let repository: CreateAccountRepository

  init(repository: CreateAccountRepository) {
    self.repository = repository
  }

  // waits for the request to finish and passes any error to the ViewModel
  func execute(input: CreateAccountInput) async throws {
    try await repository.createAccount(input: input)
  }
}
