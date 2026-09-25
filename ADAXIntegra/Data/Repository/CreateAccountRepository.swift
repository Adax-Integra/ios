//
//  CreateAccountRepository.swift
//
//
//  Created by Lakshmi Jara on 24/09/26.
//
// G-01

import Foundation

// errors that can happen while creating the account
enum CreateAccountRepositoryError: LocalizedError {
  case invalidResponse
  case server(String)

  var errorDescription: String? {
    switch self {
    case .invalidResponse:
      return "Invalid response from server"
    case .server(let message):
      return message
    }
  }
}

// sends the registration form with the backend
final class CreateAccountRepository: CreateAccountRepositoryP {
  private let baseURL = URL(string: "http:localhost:3001")!

  func createAccount(input: CreateAccountInput) async throws -> CreateAccountEntity {
    let url = baseURL.appendingPathComponent("api/external-users/register")

    let body = CreateAccountRequestModel(
      name: input.name,
      lastName: input.lastName,
      email: input.email,
      countryCode: input.countryCode,
      phone: input.phone,
      password: input.password,
      confirmPassword: input.confirmPassword
    )

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(
      "aaplication/json",
      forHTTPHeaderField: "Content-Type"
    )
    request.httpBody = try JSONEncoder().encode(body)

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let response = response as? HTTPURLResponse else {
      throw CreateAccountRepositoryError.invalidResponse
    }

    if !(200...299).contains(response.statusCode) {
      let serverError = try? JSONDecoder().decode(
        CreateAccountErrorModel.self,
        from: data
      )

      throw CreateAccountRepositoryError.server(
        serverError?.error ?? "The account could not be created"
      )
    }

    let result = try JSONDecoder().decode(
      CreateAccountResponseModel.self,
      from: data
    )

    return CreateAccountEntity(
      userId: result.data.userId,
      name: result.data.name,
      lastName: result.data.lastName,
      email: result.data.email,
      phone: result.data.phone
    )
  }
}
