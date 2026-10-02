//
//  CollaboratorManagementPage.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 01/10/26.
//



import SwiftUI

struct CollaboratorManagementPage: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var showForm = false
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var phone = ""
    
    // Temporal validator the real one will go within the ViewModel
    
    private var isFormIncomplete: Bool {
        [firstName, lastName, email, password, phone]
            .contains { $0.trimmingCharacters(in: .whitespaces).isEmpty }
    }
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            VStack {
                PageHeader(title: "Gestión de Colaboradoras",
                           backAction: { dismiss() },
                           subtitle: "Administra las cuentas de colaboradoras"
                )
                
                PrimaryButton(
                    customHeight: 20,
                    title: "Agregar Colaboradora",
                    isDisabled: false
                ){
                    showForm = true
                }
                
                Spacer()
            }
            .padding()
            
            if showForm{
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                
                ScrollView {
                    AddCollaboratiorForm(firstName: $firstName, lastName: $lastName, email: $email, password: $password, phone: $phone, isSaveDisabled: isFormIncomplete,
                                         onSave: {
                        print("Guardar colaboradora: ", firstName, lastName, email, phone)
                        closeForm()
                    },
                                         onCancel: { closeForm() }
                    )
                    
                    .padding()
                }
                .scrollBounceBehavior(.basedOnSize)
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: showForm)
        .navigationBarBackButtonHidden(true)
    }
    
    private func closeForm() {
        firstName = ""
        lastName = ""
        email = ""
        password = ""
        phone = ""
        showForm = false
    }
}



#Preview {
        CollaboratorManagementPage()
}



