//
//  ForgotPasswordPage.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 07/10/26.
//


import SwiftUI

struct ForgotPasswordPage: View {
    @Environment(\.dismiss) private var dismiss
    
    // Temporary state the real one will move in the ViewModel
    @State private var email = ""
    @State private var goToVerifyCode = false
    
    var body: some View {
        AuthFormTemplate(title: "RECUPERAR CONTRASEÑA") {
            IconTextField(
                title: "Correo electrónico",
                placeholder: "tu@correo.com",
                systemIcon: "envelope",
                keyboard: .emailAddress,
                text: $email
            )
            
            PrimaryButton(
                title: "Siguiente",
                isDisabled: email.trimmingCharacters(in: .whitespaces).isEmpty
            ) {
                // temporary the backend call will go in the ViewModel
                goToVerifyCode = true
            }
        }
        // Out to return to the login if needed
        .overlay(alignment: .topLeading) {
            BackButton { dismiss() }
                .padding(.leading, 12)
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $goToVerifyCode) {
            VerifyCodePage(email: email)
        }
    }
}


#Preview {
  NavigationStack {
    ForgotPasswordPage()
  }
}
