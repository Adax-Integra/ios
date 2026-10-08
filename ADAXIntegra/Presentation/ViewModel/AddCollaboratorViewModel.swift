//
//  AddCollaboratorViewModel.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 02/10/26.
//

import Combine
import Foundation

// Forms must match the keys used in the backend errors

enum CollaboratorField: String {
  case name
  case lastName = "last_name"
  case email
  case password
  // Only validated in the app, the backend never sends it
  case confirmPassword = "confirm_password"
  case phone

}

@MainActor
final class AddCollaboratorViewModel: ObservableObject {

  //Form Data

  @Published var firstName = ""
  @Published var lastName = ""
  @Published var email = ""
  @Published var password = ""
  @Published var confirmPassword = ""
  @Published var countryCode: String? = "+52"
  @Published var phone = ""

  // Screen state

  @Published private(set) var isSaving = false
  @Published private(set) var hasAttemptedSave = false
  @Published private var serverErrors: [CollaboratorField: String] = [:]
  @Published var generalError: String?
  @Published var successMessage: String?

  private let repository: CollaboratorRepository

  init(repository: CollaboratorRepository = RemoteCollaboratorRepository()) {
    self.repository = repository
  }

  // Errors only show after tapping "Guardar", then they update while typing

  var fieldErrors: [CollaboratorField: String] {
    guard hasAttemptedSave else { return serverErrors }
    return validate().merging(serverErrors) { local, _ in local }
  }

  // Guardar is only disabled while saving, like in "Registrar externa"

  var isSaveDisabled: Bool {
    isSaving
  }

  // Call when tap "Guardar"
  func save() async {
    hasAttemptedSave = true
    serverErrors = [:]
    generalError = nil

    guard validate().isEmpty, let countryCode else { return }

    isSaving = true
    defer { isSaving = false }

    let newCollaborador = NewCollaborator(
      name: trimmed(firstName),
      lastName: trimmed(lastName),
      email: trimmed(email).lowercased(),
      password: password,
      phone: countryCode + phone
    )
    // Final message after collaborator is saved
    do {
      _ = try await repository.createCollaborator(newCollaborador)
      successMessage =
        "Se agregó a \(newCollaborador.name) \(newCollaborador.lastName) como colaboradora."
      resetForm()
    } catch {
      print("Error al crear colaboradora: ", error)
      handle(error)
    }
  }

  // Save the rules the backend has established and sends admin feedback

  private func validate() -> [CollaboratorField: String] {
    var errors: [CollaboratorField: String] = [:]
    let required = "Este campo es obligatorio."

    let name = trimmed(firstName)
    if name.isEmpty {
      errors[.name] = required
    } else if name.count > 50 {
      errors[.name] = "El nombre debe tener máximo 50 caracteres."
    }

    let last = trimmed(lastName)
    if last.isEmpty {
      errors[.lastName] = required
    } else if last.count > 50 {
      errors[.lastName] = "Los apellidos deben tener máximo 50 caracteres."
    }

    let mail = trimmed(email)
    let emailPattern = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
    if mail.isEmpty {
      errors[.email] = required
    } else if mail.range(of: emailPattern, options: [.regularExpression, .caseInsensitive]) == nil {
      errors[.email] = "Ingresa un correo válido."
    } else if mail.count > 128 {
      errors[.email] = "El correo debe tener máximo 128 caracteres."
    }

    // Same password rules as the registration form

    if password.isEmpty {
      errors[.password] = required
    } else if !isPasswordValid(password) {
      errors[.password] = "La contraseña no cumple con los requisitos."
    }

    // Confirmation must match the password

    if confirmPassword.isEmpty {
      errors[.confirmPassword] = required
    } else if confirmPassword != password {
      errors[.confirmPassword] = "Las contraseñas no coinciden."
    }

    if phone.isEmpty {
      errors[.phone] = required
    } else if countryCode == nil {
      errors[.phone] = "Selecciona una lada."
    } else if phone.range(of: #"^\d{10}$"#, options: .regularExpression) == nil {
      errors[.phone] = "El teléfono debe tener 10 dígitos."
    }

    return errors
  }

  // 8 to 24 characters, an uppercase and a lowercase letter, a number, a special character, and no accents or special letters (only ASCII)

  private func isPasswordValid(_ password: String) -> Bool {
    (8...24).contains(password.count)
      && password.rangeOfCharacter(from: .uppercaseLetters) != nil
      && password.rangeOfCharacter(from: .lowercaseLetters) != nil
      && password.rangeOfCharacter(from: .decimalDigits) != nil
      && password.rangeOfCharacter(from: .punctuationCharacters.union(.symbols)) != nil
      && password.allSatisfy(\.isASCII)
  }

  // Turns the backend error response into messages for the admin

  private func handle(_ error: Error) {
    guard case let APIError.server(statusCode, data) = error else {
      generalError = "No se pudo conectar con el servidor. Intenta de nuevo."
      return
    }

    let body = data.flatMap { try? JSONDecoder().decode(APIErrorResponse.self, from: $0) }

    switch statusCode {
    case 400:
      var errors: [CollaboratorField: String] = [:]
      for key in (body?.errors ?? [:]).keys {
        if let field = CollaboratorField(rawValue: key) {
          errors[field] = message(for: field)
        }
      }
      serverErrors = errors
      if errors.isEmpty {
        generalError = "Revisa los datos del formulario."
      }
    case 401:
      generalError = "Tu sesión expiró. Vuelve a iniciar sesión."
    case 403: generalError = "No tienes permiso de agregar colaboradoras."
    case 409: serverErrors[.email] = "Este correo ya está registrado."
    default: generalError = "No se pudo crear a la colaboradora. Intenta de nuevo."
    }
  }

  // Spanish messages in case the backend rejects a field, since its messages come in English

  private func message(for field: CollaboratorField) -> String {
    switch field {
    case .name: return "Revisa el nombre."
    case .lastName: return "Revisa los apellidos."
    case .email: return "Revisa el correo."
    case .password: return "La contraseña no cumple con los requisitos."
    case .confirmPassword: return "Las contraseñas no coinciden."
    case .phone: return "El teléfono debe tener 10 dígitos."
    }
  }

  // Removes spaces and all line breaks at the start and end of the text as a precaution

  private func trimmed(_ text: String) -> String {
    text.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  // Leaves the form empty and without errors

  private func resetForm() {
    firstName = ""
    lastName = ""
    email = ""
    password = ""
    confirmPassword = ""
    countryCode = "+52"
    phone = ""
    hasAttemptedSave = false
    serverErrors = [:]
    generalError = nil
  }
}
