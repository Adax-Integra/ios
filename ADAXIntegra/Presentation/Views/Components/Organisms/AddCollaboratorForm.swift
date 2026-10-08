//
//  AddCollaboratorForm.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 01/10/26.
//

import SwiftUI

struct AddCollaboratorForm: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var email: String
    @Binding var password: String
    @Binding var countryCode: String?
    @Binding var phone: String

    
    var nameError: String? = nil
    var lastNameError: String? = nil
    var emailError: String? = nil
    var passwordError: String? = nil
    var phoneError: String? = nil
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            LabeledTextField(
                title: "Nombre(s)",
                placeholder: "Escribe el nombre...",
                maxLength: 50,
                errorMessage: nameError,
                text: $firstName
            )
            
            LabeledTextField(
                title: "Apellido(s)",
                placeholder: "Escribe el/los apellido(s)",
                maxLength: 50,
                errorMessage: lastNameError,
                text: $lastName
            )
            
            LabeledTextField(
                title: "Correo electrónico",
                placeholder: "correo@ejemplo.com",
                keyboardType: .emailAddress,
                errorMessage: emailError,
                text: $email
            )
            
            // It has no error parameter, so the error goes below it
            VStack(alignment: .leading, spacing: 6) {
                PasswordTextField(
                    title: "Contraseña",
                    placeholder: "Mínimo 8 caracteres",
                    text: $password
                )
                if let passwordError {
                    FieldErrorLabel(passwordError)
                }
            }
            
            PhoneField(
                errorMessage: phoneError,
                countryCode: $countryCode,
                phone: $phone
            )
        }
    }
}

#Preview {
    @Previewable @State var countryCode: String? = "+52"
    
    ScrollView {
        AddCollaboratorForm(
            firstName: .constant(""),
            lastName: .constant(""),
            email: .constant("correo-invalido"),
            password: .constant(""),
            countryCode: $countryCode,
            phone: .constant(""),
            emailError: "Ingresa un correo válido."
        )
        .padding(20)
    }
    .background(Color("Background"))
}
