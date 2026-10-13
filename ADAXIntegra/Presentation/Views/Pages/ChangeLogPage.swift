//
//  ChangeLogPage.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 05/10/26.
//

import SwiftUI

struct ChangeLogPage: View {
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    ZStack {
      Color("Background").ignoresSafeArea()

      VStack(spacing: 24) {
        PageHeader(
          title: "Bitácora de cambios",
          backAction: { dismiss() },
          subtitle: "Historial de movimientos de la app"
        )

        Spacer()

        VStack(spacing: 12) {
          Image(systemName: "clock.arrow.circlepath")
            .font(.system(size: 44))
            .foregroundStyle(Color("IconColor"))

          Text("Próximamente")
            .font(.system(size: 18, weight: .semibold))
            .foregroundStyle(Color("OnBackground"))

          Text("Aquí verás el registro de movimientos de la aplicación.")
            .font(.system(size: 14))
            .foregroundStyle(Color("IconColor"))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 32)
        }

        Spacer()
      }
      .padding()
    }
    .navigationBarBackButtonHidden(true)
  }
}

#Preview {
  ChangeLogPage()
}
