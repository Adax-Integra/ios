//
//  CreateAccountRepository.swift
//
//
//  Created by Lakshmi Jara on 24/09/26.
//
// G-01

// defines the account creation method that the repository must provide
protocol CreateAccountRepository {
  // receives the registration data and returns the created account
  func createAccount(input: CreateAccountInput) async throws
}
