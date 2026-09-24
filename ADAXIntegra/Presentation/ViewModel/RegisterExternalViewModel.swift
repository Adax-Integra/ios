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
    @Published var birthDate = Date()
    @Published var countryCode: String? = "+52"
    @Published var phone = ""
    
    @Published var addressLine1 = ""
    @Published var addressLine2 = ""
    @Published var neighborhood = ""
    @Published var zipCode = ""
    @Published var country: String? = nil
    @Published var state: String? = nil
    @Published var city = ""
    
    @Published var isSubmitting = false
    @Published var errorMessage: String?
    @Published var didSucceed = false
    
    private let repository: ExternalUserRepository
    
    init(repository: ExternalUserRepository = RemoteExternalUserRepository()) {
        self.repository = repository
    }
    
    let countries: [Country] = Country.all
    
    var stateOptions: [String] {
        Country.first(named: country ?? "", in: countries)?.states ?? []
    }
    
    var isValid: Bool {
        !name.trimmed.isEmpty
            && !lastName.trimmed.isEmpty
            && isValidEmail(email)
            && !addressLine1.trimmed.isEmpty
            && !neighborhood.trimmed.isEmpty
            && !zipCode.trimmed.isEmpty
            && country != nil
            && state != nil
            && !city.trimmed.isEmpty
    }
    
    private func isValidEmail(_ value: String) -> Bool {
        let v = value.trimmed
        return v.contains("@") && v.contains(".") && !v.hasSuffix(".")
    }
    
    func submit() async {
        guard isValid, !isSubmitting else { return }
        isSubmitting = true
        errorMessage = nil
        
        do {
            _ = try await repository.register(makeRequest())
            didSucceed = true
        } catch {
            errorMessage = "No se pudo registrar. Verifica tu conexión e inténtalo de nuevo."
        }
        
        isSubmitting = false
    }
    
    private func makeRequest() -> RegisterExternalRequest {
        RegisterExternalRequest(
            profile: .init(
                name: name.trimmed,
                lastName: lastName.trimmed,
                email: email.trimmed.lowercased(),
                birthDate: birthDateString,
                phone: phone.isEmpty ? nil : "\(countryCode ?? "")\(phone)"
            ),
            address: .init(
                addressLine1: addressLine1.trimmed,
                addressLine2: addressLine2.trimmed.isEmpty ? nil : addressLine2.trimmed,
                neighborhood: neighborhood.trimmed,
                zipCode: zipCode.trimmed,
                country: country ?? "",
                state: state ?? "",
                city: city.trimmed
            )
        )
    }
    
    private var birthDateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: birthDate)
    }
}

private extension String {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
}
