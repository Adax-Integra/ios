//
//  NewPasswordPage.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 06/10/26.
//

import SwiftUI

struct NewPasswordPage: View {
    @State private var password = ""
    @State private var confirmPassword = ""
    
    // Show error after she types the confirmation password
    
    private var passwordMismatch: Bool {
        !confirmPassword.isEmpty && password != confirmPassword
    }
    
    // temporary validation  the real one will go in the view model
    
    private var isContinueDisabled: Bool {
        password.count < 8 || password != confirmPassword
    }
    
    var body: some View {
        AuthFormTemplate(title: "Ingresa nueva contraseña") {
            VStack(alignment: .leading, spacing: 16) {
                IconTextField(
                    title: "Nueva contraseña",
                    placeholder: "*************",
                    systemIcon: "lock",
                    isSecure: true,
                    text: $password
                )
                HelperText(text: "La contraseña debe ser de 8 caracteres como mínimo")
            }
            
            VStack(alignment: .leading, spacing: 6) {
                IconTextField(
                    title: "Confirmar contraseña",
                    placeholder: "*************",
                    systemIcon: "lock",
                    isSecure: true,
                    text: $confirmPassword
                )
                
                if passwordMismatch {
                    HelperText(text: "Las contraseñas no coinciden", isError: true)
                }
            }
            
            PrimaryButton(title: "Continuar", isDisabled: isContinueDisabled) {
                // Temporary call the backed will go in the ViewModel
                print("Continuar")
            }
        }
    }
}

#Preview {
    NewPasswordPage()
}
