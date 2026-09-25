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

  // Used to log in
  private let repository: AuthRepositoryP

  // Se llama con el token cuando el login es exitoso
  private let onLogin: (LoginResult) -> Void

  init(
    repository: AuthRepositoryP,
    onLogin: @escaping (LoginResult) -> Void = { _ in }
  ) {
    self.repository = repository
    self.onLogin = onLogin
  }

  // Tries to log in with the email and password
  func login() {

    // Checks that the fields are not empty
    guard !email.isEmpty, !password.isEmpty else {
      error = "Ingresa tu correo y contraseña."
      return
    }

    // Clears previous errors
    error = nil

    // Indicates that the login process has started
    isLoading = true

    Task {

      // Sends the email and password to the repository
      let result = await repository.login(
        email: email,
        password: password
      )

      // Checks if the login returned a result
      if let result {
        isLoggedIn = true
        onLogin(result)
      } else {
        error = "No se pudo iniciar sesión."
      }

      // Ends the loading state
      isLoading = false
    }
  }
}
