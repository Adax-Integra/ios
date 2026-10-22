//
//  Untitled.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 03/10/26.
//

import SwiftUI

// G-16: the admin consults the external accounts before opening one in G-07
struct CuentasExternasPage: View {
  @StateObject private var viewModel = ExternalUserListViewModel()

  var body: some View {
    ZStack {
      Color("Background").ignoresSafeArea()

      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: 16) {
          Text("Consulta las cuentas de externas")
            .font(.subheadline)
            .foregroundColor(Color("OnBackground").opacity(0.7))

          filtersSection
          usersSection
        }
        .padding()
      }
      // hides the keyboard when the user scrolls
      .scrollDismissesKeyboard(.interactively)
    }
    .navigationTitle("Cuentas de externas")
    // Hides the keyboard of the search bar when tapping outside of it
    .dismissKeyboardOnTap()
    // Same as Expedientes: waits a little so the backend is not called on every letter.
    // It also runs when the screen appears and when coming back from G-07
    .task(id: viewModel.searchText) {
      try? await Task.sleep(for: .milliseconds(300))
      guard !Task.isCancelled else { return }
      await viewModel.loadFirstPage()
    }
    .onChange(of: viewModel.statusFilter) { _, _ in
      Task { await viewModel.loadFirstPage() }
    }
    .onChange(of: viewModel.sortOption) { _, _ in
      Task { await viewModel.loadFirstPage() }
    }
  }

  private var filtersSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      SearchBarInterna(placeholder: "Buscar por nombre o correo...", text: $viewModel.searchText)
        .autocorrectionDisabled(true)
        .textInputAutocapitalization(.never)

      HStack(spacing: 12) {
        //same as the urgency filter in "Todos los casos": a menu with one option selected
        Menu {
          Picker("Filtrar por actividad", selection: $viewModel.statusFilter) {
            Text("Todas").tag("all")
            Text("Activas").tag("active")
            Text("Inactivas").tag("inactive")
          }
        } label: {
          FilterChip(title: statusTitle)
        }
        .buttonStyle(.plain)

        Menu {
          Picker("Ordenar", selection: $viewModel.sortOption) {
            Text("Más recientes").tag("recent")
            Text("Alfabético").tag("alphabetical")
          }
        } label: {
          FilterChip(title: sortTitle)
        }
        .buttonStyle(.plain)

        Spacer()
      }
    }
  }

  // The chip shows the option that is selected
  private var statusTitle: String {
    switch viewModel.statusFilter {
    case "all": return "Todas"
    case "inactive": return "Inactivas"
    default: return "Activas"
    }
  }

  private var sortTitle: String {
    viewModel.sortOption == "alphabetical" ? "Alfabético" : "Más recientes"
  }

  private var usersSection: some View {
    VStack(alignment: .leading, spacing: 10) {
      if viewModel.errorMessage == nil && !viewModel.users.isEmpty {
        Text(viewModel.countText)
          .font(.system(size: 13))
          .foregroundColor(Color("InsideTextAndIcons"))
      }

      if viewModel.isLoading && viewModel.users.isEmpty {
        ProgressView()
          .frame(maxWidth: .infinity)
          .padding(.vertical, 24)
      } else if let errorMessage = viewModel.errorMessage, viewModel.users.isEmpty {
        errorCard(errorMessage)
      } else if viewModel.users.isEmpty {
        emptyCard
      } else {
        ForEach(viewModel.users) { item in
          userRow(item)
        }

        if viewModel.canLoadMore {
          SecondaryButton(customHeight: 20, title: "Ver más", isDisabled: viewModel.isLoading) {
            Task { await viewModel.loadNextPage() }
          }
        }
      }
    }
  }

  // Only active accounts open G-07. Inactive ones are shown but can not be opened
  @ViewBuilder
  private func userRow(_ item: ExternalUserListItem) -> some View {
    if item.isActive {
      NavigationLink {
        ExternalProfilePage(userId: item.id)
      } label: {
        ExternalUserCard(item: item, showsStatus: viewModel.statusFilter == "all")
      }
      .buttonStyle(.plain)
    } else {
      ExternalUserCard(item: item, showsStatus: true)
    }
  }

  private var emptyCard: some View {
    messageCard(
      systemImage: "person",
      iconColor: Color("PrimaryAdax"),
      title: "No hay cuentas para mostrar",
      message: "Prueba con otra búsqueda o con otro filtro."
    )
  }

  private func errorCard(_ message: String) -> some View {
    VStack(spacing: 12) {
      messageCard(
        systemImage: "exclamationmark.circle",
        iconColor: Color("Error"),
        title: "No se pudo cargar la lista",
        message: message
      )

      SecondaryButton(customHeight: 20, title: "Reintentar", isDisabled: viewModel.isLoading) {
        Task { await viewModel.loadFirstPage() }
      }
    }
  }

  private func messageCard(
    systemImage: String,
    iconColor: Color,
    title: String,
    message: String
  ) -> some View {
    VStack(spacing: 8) {
      Image(systemName: systemImage)
        .font(.system(size: 28))
        .foregroundColor(iconColor)

      Text(title)
        .font(.system(size: 16, weight: .semibold))
        .foregroundColor(Color("OnBackground"))

      Text(message)
        .font(.system(size: 14))
        .foregroundColor(Color("InsideTextAndIcons"))
        .multilineTextAlignment(.center)
    }
    .padding(24)
    .frame(maxWidth: .infinity)
    .background(
      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .fill(Color.white)
    )
  }
}

#Preview {
  NavigationStack {
    CuentasExternasPage()
  }
}
