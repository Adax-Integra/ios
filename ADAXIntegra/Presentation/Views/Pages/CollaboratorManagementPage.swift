//
//  CollaboratorManagementPage.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 01/10/26.
//

import SwiftUI

struct CollaboratorManagementPage: View {

  @Environment(\.dismiss) private var dismiss
  @State private var showAddCollaborator = false

  var body: some View {
      ZStack {
          Color("Background").ignoresSafeArea()
          
          VStack(spacing: 16) {
              PageHeader(
                title: "Gestión de Colaboradoras",
                backAction: { dismiss() },
                subtitle: "Administra las cuentas de colaboradoras"
              )
              
              // Opens form isted of navegation
              IconTextPrimaryButton(
                customHeight: 24,
                systemName: "plus",
                title: "Agregar colaboradora",
                isDisabled: false
              ) {
                  showAddCollaborator = true
              }
              
              Spacer()
          }
          
          .padding()
    }
    .navigationBarBackButtonHidden(true)
      // "Agregar colaboradora" is on a separte page now
    .navigationDestination(isPresented: $showAddCollaborator) {
        AddCollaboratorPage()
    }
  }
}

#Preview {
    NavigationStack {
        CollaboratorManagementPage()
    }
}
