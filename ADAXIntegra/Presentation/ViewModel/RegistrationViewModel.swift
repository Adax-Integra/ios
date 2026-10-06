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
  // stores the country catalog for the phone dropdown
  @Published private(set) var countries: [Country] = []

  private let countryRepository: CountryRepository
  private let createAccountUseCase: CreateAccountUseCase

  init() {
    let repository = RemoteCreateAccountRepository()
    createAccountUseCase = CreateAccountUseCase(repository: repository)
    countryRepository = RemoteCountryRepository()
  }

  // loads teh country catalog for the phone codes
  func loadCountries() async {
    do {
      countries = try await countryRepository.getCountries()
    } catch {
      errorMessage = "No se pudieron cargar las ladas."
    }
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
      try await createAccountUseCase.execute(input: input)
      accountCreated = true

    } catch {
      // reads the error detail stored by APIProtocol
      if let apiError = error as? APIError {
        switch apiError {
        case .requestFailed(let message):
          errorMessage = message
        }
      } else {
        errorMessage = error.localizedDescription
      }
    }

    isLoading = false
  }
}
