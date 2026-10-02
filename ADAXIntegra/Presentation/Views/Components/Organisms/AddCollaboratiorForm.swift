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
    let onSave: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Agregar Colaboradora")
                .font(.headline)
                .foregroundColor(Color("OnBackground"))
            
            Divider()
            
            FormTextField(label: "Nombre(s)", placeholder: "Tu nombre(s) aqui", text: $firstName)
            FormTextField(label: "Apellido", placeholder: "Tus apellido(s) aqui", text: $lastName)
            FormTextField(label: "Correo", placeholder: "tu@correo.com", keyboard: .emailAddress, text: $email)
            FormTextField(label: "Contraseña", placeholder: "Tu contraseña aqui", isSecure: true, text: $password)
            FormTextField(label: "Teléfono", placeholder: "10 dígitos", keyboard: .phonePad, text: $phone)
            
            FormActions(
                isPrimaryDisabled: isSaveDisabled, onPrimary: onSave, onSecondary: onCancel
            )
            .padding()
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
        onSave: {print ("Guardar")},
        onCancel: {print("Cancelar")}
    )
    .padding()
    .background(Color("Background"))
}
