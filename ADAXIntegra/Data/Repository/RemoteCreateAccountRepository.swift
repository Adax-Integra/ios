//
//  RemoteCreateAccountRepository.swift
//
//
//  Created by Lakshmi Jara on 24/09/26.
//
// G-01

import Foundation

// sends the registration form with the backend
struct RemoteCreateAccountRepository: CreateAccountRepository {
  func createAccount(input: CreateAccountInput) async throws {
    let body = CreateAccountRequestModel(
      name: input.name,
      lastName: input.lastName,
      email: input.email,
      countryCode: input.countryCode,
      phone: input.phone,
      password: input.password,
      confirmPassword: input.confirmPassword
    )

    let response = try await APIProtocol.post(
      "/external-user/register",
      body: body,
      as: CreateAccountResponseModel.self
    )

    guard response.success else {
      throw APIError.requestFailed("The account could not be created")
    }
  }
}
