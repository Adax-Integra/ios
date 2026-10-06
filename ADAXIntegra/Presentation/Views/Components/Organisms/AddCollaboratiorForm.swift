//
//  AddCollaboratiorForm.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 01/10/26.
//


import SwiftUI

struct AddCollaboratiorForm: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var email: String
    @Binding var password: String
    @Binding var phone: String
    var isSaveDisabled: Bool = false
    var saveTitle: String = "Guardar"
    var nameError: String? = nil
    var lastNameError: String? = nil
    var emailError: String? = nil
    var passwordError: String? = nil
    var phoneError: String? = nil
    let onSave: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Agregar Colaboradora")
                .font(.headline)
                .foregroundColor(Color("OnBackground"))
            
            Divider()
            //errorMessage: nameError
            FormTextField(label: "Nombre(s)", placeholder: "Tu nombre(s) aqui", errorMessage: nameError, text: $firstName)
            FormTextField(label: "Apellido", placeholder: "Tus apellido(s) aqui", errorMessage: lastNameError, text: $lastName)
            FormTextField(label: "Correo", placeholder: "tu@correo.com", keyboard: .emailAddress, errorMessage: emailError, text: $email)
            FormTextField(label: "Contraseña", placeholder: "Tu contraseña aqui", isSecure: true, errorMessage: passwordError, text: $password)
            FormTextField(label: "Teléfono", placeholder: "10 dígitos", keyboard: .phonePad, errorMessage: phoneError ,text: $phone)
            
            FormActions(
                primaryTitle: saveTitle,
                isPrimaryDisabled: isSaveDisabled,
                onPrimary: onSave,
                onSecondary: onCancel
            )
            .padding(.top, 8)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color("CardColor"))
        )
    }
}


#Preview {
    AddCollaboratiorForm(
        firstName: .constant(""),
        lastName: .constant(""),
        email: .constant(""),
        password: .constant(""),
        phone: .constant(""),
        isSaveDisabled: true,
        emailError: "Ingresa un email válido.",
        onSave: {print ("Guardar")},
        onCancel: {print("Cancelar")}
    )
    .padding()
    .background(Color("Background"))
}
