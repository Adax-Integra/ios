//
//  ExternalProfilePage.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 06/10/26.
//

import SwiftUI

// G-07: the admin reviews the data of an external user before editing it
struct ExternalProfilePage: View {
  @StateObject private var viewModel: ExternalProfileViewModel
  @Environment(\.dismiss) private var dismiss

  init(userId: String) {
    _viewModel = StateObject(wrappedValue: ExternalProfileViewModel(userId: userId))
  }

  var body: some View {
    ZStack {
      Color("Background").ignoresSafeArea()

      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: 16) {
          PageHeader(
            title: "Datos de la externa",
            backAction: { dismiss() },
            subtitle: "Gestión de usuarios"
          )

          if viewModel.isLoading && viewModel.profile == nil {
            ProgressView()
              .frame(maxWidth: .infinity)
              .padding()
          } else if viewModel.profile != nil {
            profileCard
            registrationSection
            contactSection
            addressSection

            PrimaryButton(customHeight: 20, title: "Editar datos", isDisabled: false) {
              viewModel.startEditing()
            }
          }
        }
        .padding(20)
      }
    }
    .toolbar(.hidden, for: .navigationBar)
    .task { await viewModel.load() }
    .navigationDestination(isPresented: $viewModel.isEditing) {
      EditExternalProfilePage(viewModel: viewModel)
    }
    .toast(isPresented: $viewModel.isShowingSuccessToast, message: "Datos actualizados", edge: .top)
    // The edit page shows its own alert, so this one only runs on the detail
    .alert(
      "Aviso",
      isPresented: Binding(
        get: { viewModel.errorMessage != nil && !viewModel.isEditing },
        set: { if !$0 { viewModel.errorMessage = nil } }
      )
    ) {
      Button("Aceptar", role: .cancel) {}
    } message: {
      Text(viewModel.errorMessage ?? "")
    }
  }
  private var profileCard: some View {
    SurfaceCard {
      HStack(spacing: 16) {
        Text(viewModel.initials)
          .font(.system(size: 24, weight: .bold))
          .foregroundColor(Color("PrimaryAdax"))
          .frame(width: 64, height: 64)
          .background(Circle().fill(Color("PrimaryAdax").opacity(0.12)))

        VStack(alignment: .leading, spacing: 4) {
          Text(viewModel.displayName)
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(Color("OnBackground"))

          Text("Externa")
            .font(.system(size: 14))
            .foregroundColor(Color("InsideTextAndIcons"))

          Label(viewModel.display(viewModel.saved.email), systemImage: "envelope")
            .font(.system(size: 13))
            .foregroundColor(Color("InsideTextAndIcons"))
        }

        Spacer(minLength: 0)
      }
      .padding(20)
    }
  }

  private var registrationSection: some View {
    ProfileSectionCard(title: "Datos de registro", isLocked: true) {
      InfoRow(label: "Nombre(s)", value: viewModel.display(viewModel.profile?.profile?.name))
      InfoRow(label: "Apellidos", value: viewModel.display(viewModel.profile?.profile?.lastName))
      InfoRow(label: "Fecha de nacimiento", value: viewModel.birthDateText)
    }
  }

  private var contactSection: some View {
    ProfileSectionCard(title: "Contacto") {
      InfoRow(label: "Correo electrónico", value: viewModel.display(viewModel.saved.email))
      InfoRow(
        label: "Teléfono celular",
        value: viewModel.display(viewModel.phoneText(for: viewModel.saved)))
    }
  }

  // In the same order as the "Registrar externa" form
  private var addressSection: some View {
    ProfileSectionCard(title: "Domicilio") {
      InfoRow(label: "País", value: viewModel.display(viewModel.saved.country))
      InfoRow(label: "Estado", value: viewModel.display(viewModel.saved.state))
      InfoRow(label: "Municipio/Localidad", value: viewModel.display(viewModel.saved.municipality))
    }
  }
}

#Preview {
  NavigationStack {
    ExternalProfilePage(userId: "00000000-0000-4000-8000-000000000000")
  }
}
