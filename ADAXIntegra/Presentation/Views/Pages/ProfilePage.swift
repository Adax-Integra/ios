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
  @State private var showLogoutConfirmation = false

  // Same rule as ViewAndEditProfileViewModel: staff roles take precedence
  private var isExternal: Bool {
    session.roles.contains("external") && !session.roles.contains("admin")
      && !session.roles.contains("internal")
  }

  var body: some View {
    NavigationStack {
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
      .toolbar(.hidden, for: .navigationBar)
      .task { await viewModel.loadProfile(for: session.userId) }
      .alert("Cerrar sesión", isPresented: $showLogoutConfirmation) {
        Button("Cerrar sesión") {
          Task { await session.logout() }
        }
        Button("Cancelar", role: .cancel) {}
      } message: {
        Text("¿Quieres cerrar tu sesión?")
      }
    }
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

      NavigationLink {
        ViewAndEditProfilePage(userId: session.userId, roles: session.roles)
      } label: {
        MenuRow(
          icon: "person",
          title: "Datos Personales",
          subtitle: isExternal ? "Nombre, teléfono, dirección" : "Nombre, teléfono"
        )
      }

      // R-06: hook up the upload documents page once it exists
      Button {
      } label: {
        MenuRow(
          icon: "person.text.rectangle",
          title: "Mis documentos",
          subtitle: "INE y comprobante de domicilio"
        )
      }

      NavigationLink {
        ChangePasswordPage()
      } label: {
        MenuRow(
          icon: "lock",
          title: "Seguridad",
          subtitle: "Cambio de contraseña"
        )
      }

      Spacer()

      PrimaryButton(
        title: "Cerrar sesión",
        isDisabled: false,
        action: { showLogoutConfirmation = true }
      )
    }
    .padding(20)
  }
}

#Preview {
  ProfilePage()
    .environmentObject(AuthSession())
}
