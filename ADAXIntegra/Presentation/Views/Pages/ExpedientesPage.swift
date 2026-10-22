//
//  ExpedientesPage.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 30/09/26.
//

import SwiftUI

struct ExpedientesPage: View {
  // G-16: the external accounts list is only for the admin
  @EnvironmentObject private var session: AuthSession

  var body: some View {
    ScrollView {
      VStack(
        alignment: .leading,
        spacing: 16
      ) {
        Text("Expedientes").font(.system(size: 22, weight: .bold))
        Text("Consulta toda tu información aquí").font(.system(size: 13, weight: .medium))
          .foregroundStyle(Color("IconColor"))

        NavigationLink {
          ExpedientesListPage()
        } label: {
          MenuRow(
            icon: "folder",
            title: "Expedientes",
            subtitle: "Consulta todos los expedientes"
          )
        }

        NavigationLink {
          CasesPageInterna()
        } label: {
          MenuRow(
            icon: "folder",
            title: "Todos los casos",
            subtitle: "Consulta los casos"
          )
        }

        // V-12: cases assigned to the logged-in collaborator
        NavigationLink {
          MyCasesPage()
        } label: {
          MenuRow(
            icon: "person",
            title: "Mis casos",
            subtitle: "Casos que yo llevo"
          )
        }

        if session.roles.contains("admin") || session.roles.contains("internal") {
          NavigationLink {
            CuentasExternasPage()
          } label: {
            MenuRow(
              icon: "person",
              title: "Cuentas externas",
              subtitle: "Control de cuentas"
            )
          }
        }

        NavigationLink {
          ReportPage(viewModel: ReportViewModel(repository: RemoteReportRepository()))
        } label: {
          MenuRow(
            icon: "arrow.down.document",
            title: "Reportes",
            subtitle: "Genera reportes sobre casos"
          )
        }

      }
      .padding(16)
    }
    .background(Color("BackgroundColor"))
  }
}
