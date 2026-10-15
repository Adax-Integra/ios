//
//  AuthFormTemplate.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 06/10/26.
//



import SwiftUI

// Generic template "Content" because whe dont know the expected value because it could be to create a new password or to recover a password

struct AuthFormTemplate<Content: View>: View {
    
    let title: String
    @ViewBuilder let content: Content
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Image("adaxFairy")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 48)
                    .padding(.bottom, 16)
                
                
                Text(title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color("PrimaryAdax"))
                
                
                content
            }
            .padding(.horizontal, 28)
        }
        
        //hides the keyboard when the user scrolls
        .scrollDismissesKeyboard(.interactively)
        .background(Color("Background").ignoresSafeArea())
    }
}


#Preview {
    @Previewable @State var email = ""
    AuthFormTemplate(title: "RECUPERAR CONTRASEÑA") {
    IconTextField(
        title: "Correo electrónico",
        placeholder: "tu@correo.com",
        systemIcon: "envelope",
        keyboard: .emailAddress,
        text: $email
        )
    
        PrimaryButton(title: "Siguiente", isDisabled: false) {
            print("Siguiente")
        }
    }
}
