//
//  VerifyCodePage.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 06/10/26.
//
import SwiftUI

struct VerifyCodePage: View {
    @Environment(\.dismiss) private var dismiss
    
    let email: String
    
    // Temoporary data the state will go with in the viewmodel
    
    @State private var code = ""
    @State private var secondsUntilResend = 60
    @State private var attempt = 1
    @State private var goToNewPassword = false
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                PageHeader(title: "Verifica tu cuenta", backAction: { dismiss() })
                
                Text("Enviamos un código de 6 dígitos a tu correo. Ingrésalo para recuperar tu contraseña. Si no lo ves, revisa tu carpeta de spam.")
                    .font(.system(size: 15))
                    .foregroundColor(Color("IconColor"))
                
                CodeSentCard(email: email)
                
                VerificationCodeCard(
                    code: $code,
                    secondsUntilResend: secondsUntilResend,
                    attempt: attempt,
                    onResend: { secondsUntilResend = 60 }
                )
                
                Button {
                    secondsUntilResend = 60
                } label: {
                    Text("¿No recibiste el código?")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(secondsUntilResend > 0 ? Color("IconColor") : Color("PrimaryAdax"))
                        .underline(secondsUntilResend == 0)
                }
                .buttonStyle(.plain)
                .disabled(secondsUntilResend > 0)
                .frame(maxWidth: .infinity)
                
                Spacer()
                
                PrimaryButton(title: "Verificar", isDisabled: code.count < 6) {
                    goToNewPassword = true
                }
            }
            
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $goToNewPassword) {
            NewPasswordPage()
        }
        
        // Temporary countdown that subtracts one second until it reaches 0
        .task(id: secondsUntilResend) {
            guard secondsUntilResend > 0 else { return }
            try? await Task.sleep(for: .seconds(1))
            guard !Task.isCancelled else { return }
            secondsUntilResend -= 1
        }
    }
}

#Preview {
  NavigationStack {
    VerifyCodePage(email: "nico•••••@gmail.com")
  }
}

