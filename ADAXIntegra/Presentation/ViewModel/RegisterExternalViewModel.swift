//
//  RegisterExternalViewModel.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 24/09/26.
//

import Foundation
import Combine


final class RegisterExternalViewModel: ObservableObject {
    @Published var name = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var birthDateInput = ""
    @Published var countryCode: String? = "+52"
    @Published var phone = ""
    
    @Published var country: String? = nil
    @Published var state: String? = nil
    @Published var municipality = ""
    
    @Published var isSubmitting = false
    @Published var errorMessage: String?
    @Published var didSucceed = false
    
    @Published var result: RegisterExternalResult?
    
    @Published var showErrors = false
    @Published var showErrorToast = false
    
    private let repository: ExternalUserRepository
    private let countryRepository: CountryRepository
    
    @Published private(set) var countries: [Country] = []
    
    init(
        repository: ExternalUserRepository = RemoteExternalUserRepository(),
        countryRepository: CountryRepository = CachedCountryRepository(remote: RemoteCountryRepository())
    ) {
        self.repository = repository
        self.countryRepository = countryRepository
    }
    
    func loadCountries() async {
        do {
            countries = try await countryRepository.getCountries()
        } catch {
            errorMessage = "No se pudieron cargar los países."
        }
    }
    
    var stateOptions: [String] {
        Country.first(name: country ?? "", in: countries)?.stateNames ?? []
    }
    
    var birthDate: Date? { Self.uiDateFormatter.date(from: birthDateInput) }
    
    var birthDateError: String? {
        if birthDateInput.isEmpty { return nil }
        guard let date = birthDate else {
            return "Fecha inválida (usa dd/mm/aaaa)"
        }
        if date > Date() {
            return "La fecha no puede ser futura"
        }
        if let minAdultDate = Calendar.current.date(byAdding: .year, value: -18, to: Date()),
           date > minAdultDate {
            return "La externa debe ser mayor de edad (18+)"
        }
        return nil
    }
    
    func setBirthDate(_ date: Date) {
        birthDateInput = Self.uiDateFormatter.string(from: date)
    }
    
    static let uiDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "es_MX")
        f.dateFormat = "dd/MM/yyyy"
        f.isLenient = false
        return f
    }()
    
    static let backendDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
    
    var isValid: Bool {
        !name.trimmed.isEmpty
            && !lastName.trimmed.isEmpty
            && isValidEmail(email)
            && country != nil
            && state != nil
            && !municipality.trimmed.isEmpty
            && birthDateError == nil
    }
    
    private func isValidEmail(_ value: String) -> Bool {
        let v = value.trimmed
        return v.contains("@") && v.contains(".") && !v.hasSuffix(".")
    }
    
    private func requiredError(_ value: String) -> String? {
        guard showErrors else { return nil }
        return value.trimmed.isEmpty ? "Este campo es obligatorio" : nil
    }
    
    var nameError: String? { requiredError(name) }
    var lastNameError: String? { requiredError(lastName) }
    var emailError: String? {
        guard showErrors else { return nil }
        if email.trimmed.isEmpty { return "Este campo es obligatorio" }
        return isValidEmail(email) ? nil : "Correo no válido (usa nombre@dominio.com)"
    }
    var municipalityError: String? { requiredError(municipality) }
    var countryError: String? {showErrors && country == nil ? "Selecciona un país" : nil }
    var stateError: String? {showErrors && state == nil ? "Selecciona un estado" : nil }
    
    func submit() async {
        showErrors = true
        guard isValid, !isSubmitting else { return }
        isSubmitting = true
        errorMessage = nil
        
        do {
            result = try await repository.register(makeRequest())
            didSucceed = true
        } catch {
            errorMessage = Self.registerErrorMessage(from: error)
            showErrorToast = true
        }
        
        isSubmitting = false
    }
    
    private func makeRequest() -> RegisterExternalRequest {
        RegisterExternalRequest(
            profile: .init(
                name: name.trimmed,
                lastName: lastName.trimmed,
                email: email.trimmed.lowercased(),
                birthDate: birthDate.map { Self.backendDateFormatter.string(from: $0)},
                phone: phone.isEmpty ? nil : "\(countryCode ?? "")\(phone)"
            ),
            address: .init(
                country: country ?? "",
                state: state ?? "",
                municipality: municipality.trimmed
            )
        )
    }
    
    private static func registerErrorMessage(from error: Error) -> String {
        guard case let APIError.server(_, data) = error,
              let data,
              let body = try? JSONDecoder().decode(APIErrorResponse.self, from: data),
              let message = body.error
        else {
            return "No se pudo registrar. Verifica tu conexión e inténtalo de nuevo."
        }
        
        if message.lowercased().contains("exists") {
            return "Ya existe una externa registrada con este correo."
        }
        return "No se pudo registrar. Revisa los datos e inténtalo de nuevo."
    }
}

private extension String {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
}
