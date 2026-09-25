//
//  CreateAccountRepositoryP.swift
//
//
//  Created by Lakshmi Jara on 24/09/26.
//
// G-01

// operation needed to create an account
protocol CreateAccountRepositoryP {
  func createAccount(input: CreateAccountInput) async throws -> CreateAccountEntity
}
