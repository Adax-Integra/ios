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
            subtitle: "Desglose Mensual de Expedientes"
          )
        }

        NavigationLink {
          CasesPageInterna()
        } label: {
          MenuRow(
            icon: "folder",
            title: "Todos los casos",
            subtitle: "Actividades en curso"
          )
        }

        if session.roles.contains("admin") {
          NavigationLink {
            CuentasExternasPage()
          } label: {
            MenuRow(
              icon: "person",
              title: "Cuentas Externas",
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
            subtitle: "Desglose mensual de expedientes"
          )
        }

      }
      .padding(16)
    }
    .background(Color("BackgroundColor"))
  }
}
