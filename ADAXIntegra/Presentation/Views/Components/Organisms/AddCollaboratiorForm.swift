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
            
            FormTextField(label: "Nombre(s)", text: $firstName)
            FormTextField(label: "Apellido", text: $lastName)
            FormTextField(label: "Correo",keyboard: .emailAddress, text: $email)
            FormTextField(label: "Contraseña", isSecure: true, text: $password)
            FormTextField(label: "Telefono", placeholder: "10 digitos", keyboard: .phonePad, text: $phone)
            
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
