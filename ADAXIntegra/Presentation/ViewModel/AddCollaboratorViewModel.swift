//
//  AddCollaboratorViewModel.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 02/10/26.
//

import Combine
import Foundation

// Forms must match thekey with in the backend used errors

enum CollaboratorField: String {
  case name
  case lastName = "last_name"
  case email
  case password
  case phone

}

@MainActor
final class AddCollaboratorViewModel: ObservableObject {

  //Form Data

  @Published var firstName = ""
  @Published var lastName = ""
  @Published var email = ""
  @Published var password = ""
  @Published var countryCode: String? = "+52"
  @Published var phone = ""

  // Screen state

  @Published private(set) var isSaving = false
  @Published private(set) var fieldErrors: [CollaboratorField: String] = [:]
  @Published var generalError: String?
  @Published var successMessage: String?

  private let repository: CollaboratorRepository

  init(repository: CollaboratorRepository = RemoteCollaboratorRepository()) {
    self.repository = repository
  }

  // Guardar say disable until form is fully completed

  var isSaveDisabled: Bool {
    isSaving
      || countryCode == nil
      || [firstName, lastName, email, password, phone]
        .contains {
          $0.trimmingCharacters(in: .whitespaces).isEmpty
        }
  }

  // Call when tap "Guardar"
  func save() async {
    generalError = nil
    fieldErrors = validate()
    guard fieldErrors.isEmpty, let countryCode else { return }

    isSaving = true
    defer { isSaving = false }

    let newCollaborador = NewCollaborator(
      name: trimmed(firstName),
      lastName: trimmed(lastName),
      email: trimmed(email).lowercased(),
      password: password,
      phone: countryCode + phone
    )
    // Final message after colaborator is saved
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

    let name = trimmed(firstName)
    if name.isEmpty {
      errors[.name] = "Ingresa el nombre."
    } else if name.count > 50 {
      errors[.name] = "El nombre debe tener máximo 50 caracteres."
    }

    let last = trimmed(lastName)
    if last.isEmpty {
      errors[.lastName] = "Ingresa los apellidos."
    } else if last.count > 50 {
      errors[.lastName] = "Los apellidos deben tener máximo 50 caracteres."
    }

    let mail = trimmed(email)
    let emailPattern = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
    if mail.range(of: emailPattern, options: [.regularExpression, .caseInsensitive]) == nil {
      errors[.email] = "Ingresa un email válido."
    } else if mail.count > 128 {
      errors[.email] = "El correo debe tener máximo 128 caracteres."
    }

    if password.count < 8 {
      errors[.password] = "La contraseña debe tener al menos 8 caracteres."
    } else if password.count > 128 {
      errors[.password] = "La contraseña debe tener máximo 128 caracteres."
    }

    if phone.range(of: #"^\d{10}$"#, options: .regularExpression) == nil {
      errors[.phone] = "El teléfono debe tener 10 dígitos."
    }

    return errors
  }

  // Turns the backend error responsable into messages for th admin

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
      fieldErrors = errors
      if errors.isEmpty {
        generalError = "Revisa los datos del formulario."
      }
    case 401:
      generalError = "Tu sesión expiró. Vuelve a iniciar sesión"
    case 403: generalError = "No tienes permiso de agregar colaboradoras."
    case 409: fieldErrors[.email] = "Este correo ya está registrado."
    default: generalError = "No se pudo crear a la colaboradora. Intenta de nuevo."
    }
  }

  // Spansih message in case the backend rejects the english version. It sends messages in spanish

  private func message(for field: CollaboratorField) -> String {
    switch field {
    case .name: return "Revisa el nombre."
    case .lastName: return "Revisa los apellidos."
    case .email: return "Revisa el correo."
    case .password: return "La contraseña debe tener entre 8 y 128 caracteres."
    case .phone: return "El teléfono debe de tener 10 dígitos."
    }
  }

  // Removes spaces and all line breaks at the start and end of the text as a precusion

  private func trimmed(_ text: String) -> String {
    text.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  // Leaves the form empty and without errors

  private func resetForm() {
    firstName = ""
    lastName = ""
    email = ""
    password = ""
    countryCode = "+52"
    phone = ""
    fieldErrors = [:]
    generalError = nil
  }
}
