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
      ScrollView {
        VStack(alignment: .leading, spacing: 16) {
          Text("Administración").font(.system(size: 22, weight: .bold))
          Text("Administra la plataforma").font(.system(size: 13, weight: .medium))
            .foregroundStyle(Color("IconColor"))

          NavigationLink {
            CollaboratorManagementPage()
          } label: {
            MenuRow(
              icon: "person.2",
              title: "Gestión de colaboradoras",
              subtitle: "Alta y control de cuentas"
            )
          }
        }
        .padding(16)
      }
      .background(Color("BackgroundColor"))
    }
  }
}

#Preview {
  AdminPage()
}
