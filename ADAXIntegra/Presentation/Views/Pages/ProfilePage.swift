//
//  ProfilePage.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 22/09/26.
//

import SwiftUI

struct ProfilePage: View {
  @EnvironmentObject private var session: AuthSession

  var body: some View {
    ZStack {
      Color("Background").ignoresSafeArea()

      VStack(alignment: .leading, spacing: 16) {
        ProfileHeader(
          initials: "CH",
          fullName: "Celine Hernández Alonso",
          memberSince: "Desde jul 2024"
        )

        Text("Información Personal")
          .font(.system(size: 15, weight: .semibold))
          .foregroundColor(Color("OnBackground"))
          .padding(.top, 8)

        MenuRow(
          icon: "person",
          title: "Datos Personales",
          subtitle: "Nombre, teléfono, correo"
        )
        MenuRow(
          icon: "lock",
          title: "Seguridad",
          subtitle: "Cambio de contraseña"
        )
        MenuRow(
          icon: "bell",
          title: "Notificaciones",
          subtitle: "Preferencia de notificaciones"
        )

        Spacer()

        PrimaryButton(
          title: "Cerrar sesión",
          isDisabled: false,
          action: { session.logout() }
        )
      }
      .padding(20)
    }
  }
}

#Preview {
  ProfilePage()
    .environmentObject(AuthSession())
}
