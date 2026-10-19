//
//  LoginViewModel.swift
//  ADAXIntegra
//
//  Created by Laura Cintora on 22/09/26.
//

import Combine
import Foundation

// Updates the interface when the data changes
@MainActor
class LoginViewModel: ObservableObject {

  //  Data entered by the user
  @Published var email: String = ""
  @Published var password: String = ""

  // Login status
  @Published var isLoading: Bool = false
  @Published var isLoggedIn: Bool = false

  // Stores a message if an error occurs
  @Published var error: String?

  // G-09: email of an account that still has to be verified opens "Verifica tu cuenta"
  @Published var pendingVerificationEmail: String?

  // Used to log in
  private let repository: AuthRepository

  // Se llama con el token cuando el login es exitoso
  private let onLogin: (LoginResult) -> Void

  init(
    repository: AuthRepository,
    onLogin: @escaping (LoginResult) -> Void = { _ in }
  ) {
    self.repository = repository
    self.onLogin = onLogin
  }

  // Tries to log in with the email and password
  func login() {

    // Removes spaces at the start and end of the email

    let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

    // Checks that the fields are not empty
    guard !cleanEmail.isEmpty, !password.isEmpty else {
      error = "Ingresa tu correo y contraseña."
      return
    }

    // Clears previous errors
    error = nil

    // Indicates that the login process has started
    isLoading = true

    Task {
      do {
        // Sends the email and password to the repository
        let result = try await repository.login(email: cleanEmail, password: password)
        isLoggedIn = true
        onLogin(result)
      } catch {
        // G-09: checks if the account still has to be verified
        handle(error, email: cleanEmail)
      }

      // Ends the loading state
      isLoading = false
    }
  }

  // G-09: an unverified account goes to "Verifica tu cuenta" and any other error keeps the message
  private func handle(_ error: Error, email: String) {
    print("Error al iniciar sesión: ", error)

    if case let APIError.server(_, data) = error,
      let data,
      let body = try? JSONDecoder().decode(APIErrorResponse.self, from: data),
      body.code == "EMAIL_NOT_VERIFIED"
    {
      pendingVerificationEmail = email
      return
    }

    // No answer from the server (no internet or timeout)
    guard case APIError.server = error else {
      self.error = "No se pudo conectar. Revisa tu conexión a internet."
      return
    }

    // Any answer from the backend that is an error
    self.error = "No se pudo iniciar sesión."
  }
}
