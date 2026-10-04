//
//  RegistrationViewModel.swift
//  ADAXIntegra
//
//  Created by Lakshmi Jara on 24/09/26.
//
// G-01

import Combine
import Foundation

// keeps changes to the screen's state on the main actor
@MainActor
final class RegistrationViewModel: ObservableObject {
  @Published var isLoading = false
  @Published var errorMessage: String?
  @Published var accountCreated = false

  private let createAccountUseCase: CreateAccountUseCase

  init() {
    let repository = CreateAccountRepository()
    createAccountUseCase = CreateAccountUseCase(repository: repository)
  }

  // sends the form data to create the account
  func createAccount(
    name: String,
    lastName: String,
    email: String,
    countryCode: String,
    phone: String,
    password: String,
    confirmPassword: String
  ) async {

    // marks the start of the request and clears any previous error
    isLoading = true
    errorMessage = nil
    accountCreated = false

    // groups the form values into one object
    let input = CreateAccountInput(
      name: name,
      lastName: lastName,
      email: email,
      countryCode: countryCode,
      phone: phone,
      password: password,
      confirmPassword: confirmPassword
    )

    do {
      let account = try await createAccountUseCase.execute(input: input)

      if !account.userId.isEmpty {
        accountCreated = true
      }
    } catch {
      errorMessage = error.localizedDescription
    }

    isLoading = false
  }
}
