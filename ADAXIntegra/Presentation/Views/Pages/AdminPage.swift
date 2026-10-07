//
//  AdminPage.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 01/10/26.
//

import SwiftUI

struct AdminPage: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Administración")
                        .font(.system(size: 22, weight: .bold))
                    Text("Gestiona las acciones de administrador")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color("IconColor"))
                    
                    NavigationLink {
                        CollaboratorManagementPage()
                    } label: {
                        MenuRow(
                            icon: "person.2",
                            title: "Gestión de colaboradoras",
                            subtitle: "Da de alta y administra colaboradoras"
                        )
                    }
                    
                    NavigationLink {
                        CuentasExternasPage()
                    } label: {
                        MenuRow(
                            icon: "person",
                            title: "Cuentas de externas",
                            subtitle: "Administra las cuentas de externas"
                        )
                    }
                    
                    NavigationLink {
                        ChangeLogPage()
                    } label: {
                        MenuRow(
                            icon: "clock.arrow.circlepath",
                            title: "Bitácora de cambios",
                            subtitle: "Historial de movimientos de la app"
                        )
                    }
                }
                .padding(16)
            }
            .background(Color("BackgroundColor"))
        }
    }
  }
}

#Preview {
  AdminPage()
}
