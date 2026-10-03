//
//  AdminPage.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 01/10/26.
//

import SwiftUI

struct AdminPage: View {
  @State private var showCollaboratorManagment = false

  var body: some View {
    NavigationStack {
      ZStack {
        Color("Background").ignoresSafeArea()

        VStack(alignment: .leading, spacing: 24) {
          Text("Administración")
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(Color("OnBackground"))

          PrimaryButton(
            customHeight: 20,
            title: "Gestion de colaboradoras",
            isDisabled: false
          ) {
            showCollaboratorManagment = true
          }

          Spacer()
        }
        .padding()
      }
      .navigationDestination(isPresented: $showCollaboratorManagment) {
        CollaboratorManagementPage()
      }
    }
  }
}

#Preview {
  AdminPage()
}
