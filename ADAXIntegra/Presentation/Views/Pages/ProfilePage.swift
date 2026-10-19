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
  @State private var showDeactivateConfirmation = false
  @State private var showDeactivateError = false
  @State private var isDeactivating = false

  // Same rule as ViewAndEditProfileViewModel: staff roles take precedence
  private var isExternal: Bool {
    session.roles.contains("external") && !session.roles.contains("admin")
      && !session.roles.contains("internal")
  }

  private var canDeactivate: Bool {
    !session.roles.contains("admin")
      && (session.roles.contains("external") || session.roles.contains("internal"))
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
      .alert("Desactivar cuenta", isPresented: $showDeactivateConfirmation) {
        Button("Desactivar", role: .destructive) {
          isDeactivating = true
          Task {
            let success = await session.deactivateAccount()
            if !success {
              isDeactivating = false
              showDeactivateError = true
            }
          }
        }
        Button("Cancelar", role: .cancel) {}
      } message: {
        Text(
          "Tu cuenta quedará inactiva y no podrás volver a iniciar sesión. Esta acción no se puede deshacer."
        )
      }
      .alert("No se pudo desactivar la cuenta", isPresented: $showDeactivateError) {
        Button("Entendido", role: .cancel) {}
      } message: {
        Text("Revisa tu conexión e inténtalo de nuevo.")
      }
    }
  }

  private var content: some View {
    VStack(alignment: .leading, spacing: 16) {
      ProfileHeader(
        initials: viewModel.initials,
        fullName: viewModel.fullName,
        memberSince: viewModel.memberSince
      ) {
        if isExternal {
          VerificationBadge(
            status: viewModel.profile?.verification ?? .noVerificado
          )
          .padding(.top, 2)
        }
      }

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

      NavigationLink {
        ChangePasswordPage()
      } label: {
        MenuRow(
          icon: "lock",
          title: "Seguridad",
          subtitle: "Cambio de contraseña"
        )
      }

      // R-06: only external users upload identity documents
      if isExternal {
        NavigationLink {
          IdentityDocumentsPage(userId: session.userId)
        } label: {
          MenuRow(
            icon: "person.text.rectangle",
            title: "Mis documentos",
            subtitle: "INE y comprobante de domicilio"
          )
        }
      }

      if canDeactivate {
        Text("Acciones")
          .font(.system(size: 15, weight: .semibold))
          .foregroundColor(Color("OnBackground"))
          .padding(.top, 8)

        Button {
          showDeactivateConfirmation = true
        } label: {
          DangerMenuRow(
            icon: "trash",
            title: "Desactivar cuenta",
            subtitle: "Esta acción no se puede deshacer"
          )
        }
        .buttonStyle(.plain)
        .disabled(isDeactivating)
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
