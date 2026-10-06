//
//  ProfilePage.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 22/09/26.
//

import SwiftUI

struct ProfilePage: View {
  @EnvironmentObject private var session: AuthSession
  @StateObject private var viewModel = ProfileViewModel()

  var body: some View {
    ZStack {
      Color("Background").ignoresSafeArea()

      if viewModel.isLoading {
        ProgressView()
      } else if let errorMessage = viewModel.errorMessage {
        Text(errorMessage)
          .font(.system(size: 15))
          .foregroundColor(Color("InsideTextAndIcons"))
          .multilineTextAlignment(.center)
          .padding(20)
      } else if viewModel.profile != nil {
        content
      }
    }
    .task { await viewModel.loadProfile(for: session.userId) }
  }

  private var content: some View {
    VStack(alignment: .leading, spacing: 16) {
      ProfileHeader(
        initials: viewModel.initials,
        fullName: viewModel.fullName,
        memberSince: viewModel.memberSince
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

#Preview {
  ProfilePage()
    .environmentObject(AuthSession())
}
