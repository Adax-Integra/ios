//
//  CollaboratorDetailPage.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 17/10/26.
//
// General page for US g-1o where the admin gets the detail of an internal user

import SwiftUI
import UIKit

// The admin and ONLY ADMIN consults the information and the cases of a collaborator
struct CollaboratorDetailPage: View {
  @StateObject private var viewModel: CollaboratorDetailViewModel
  @Environment(\.dismiss) private var dismiss
  // G-18: shows or hides the edit screen
  @State private var showEdit = false
  private let userId: String
  // G-04: shows or hides the confirmation dialog
  @State private var showStatusDialog = false
  // G-04: used to log out when the session expires (401)
  @EnvironmentObject private var session: AuthSession

  init(userId: String) {
    self.userId = userId
    _viewModel = StateObject(wrappedValue: CollaboratorDetailViewModel(userId: userId))
  }

  var body: some View {
    ZStack {
      Color("Background").ignoresSafeArea()

        GeometryReader { geo in
          ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
              PageHeader(
                title: "Detalle de colaboradora",
                backAction: { dismiss() },
                subtitle: "Gestión de colaboradoras"
              )

              content
            }
            .padding(20)
            .frame(width: geo.size.width, alignment: .leading)
          }
          .refreshable {
            await viewModel.load(force: true)
            if viewModel.selectedTab == .cases {
              await viewModel.loadCases(force: true)
            }
          }
        }

      // G-04: dark background and confirmation dialog
      if showStatusDialog, let detail = viewModel.detail {
        Color.black.opacity(0.4)
          .ignoresSafeArea()
          .onTapGesture {
            // It cannot be closed while saving
            if !viewModel.isUpdatingStatus {
              showStatusDialog = false
            }
          }

        ChangeStatusDialog(
          collaboratorName: detail.fullName,
          isActive: detail.isActive,
          isLoading: viewModel.isUpdatingStatus,
          onConfirm: {
            Task {
              await viewModel.changeStatus()
              showStatusDialog = false
            }
          },
          onCancel: { showStatusDialog = false }
        )
      }
    }
    .toolbar(.hidden, for: .navigationBar)
    .task { await viewModel.load() }
    .toast(isPresented: $viewModel.isShowingCopiedToast, message: "Copiado al portapapeles")
    // G-18: open the edit screen
    .navigationDestination(isPresented: $showEdit) {
      EditCollaboratorProfilePage(userId: userId) {
        // Reload the detail when the edit screen saved changes
        Task { await viewModel.load(force: true) }
      }
    }
    // G-04: success or error message
    .toast(isPresented: $viewModel.isShowingStatusToast, message: viewModel.statusToastMessage)
    // G-04: if the session expired (401), log out and go back to the login
    .onChange(of: viewModel.shouldGoToLogin) { _, goToLogin in
      if goToLogin {
        Task { await session.logout() }
      }
    }
  }

  @ViewBuilder
  private var content: some View {
    if let detail = viewModel.detail {
      CollaboratorProfileCard(
        initials: detail.initials,
        fullName: detail.fullName,
        roleText: viewModel.roleText,
        memberSinceText: viewModel.memberSinceText,
        isActive: detail.isActive
      )

      PillTabSelector(
        tabs: [CollaboratorDetailTab.general, .cases],
        selection: $viewModel.selectedTab
      ) { tab in
        tab == .general ? "General" : "Casos"
      }

      switch viewModel.selectedTab {
      case .general: generalTab(detail)
      case .cases: casesTab
      }
    } else if let message = viewModel.errorMessage {
      errorCard(message) {
        Task { await viewModel.load() }
      }
    } else {
      ProgressView()
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
    }
  }

  // General tab

  private func generalTab(_ detail: CollaboratorDetail) -> some View {
    VStack(spacing: 16) {
      CollaboratorContactCard(
        email: detail.email,
        phoneText: viewModel.phoneText,
        canCopyPhone: !(detail.phone ?? "").isEmpty,
        onCopyEmail: { copy(detail.email) },
        onCopyPhone: { copy(detail.phone ?? "") }
      )

      CollaboratorOrganizationCard(
        roleText: viewModel.roleText,
        officeText: viewModel.officeText,
        joinedAtText: viewModel.joinedAtText
      )

      CollaboratorStatusCard(
        isActive: detail.isActive,
        description: viewModel.statusDescription
      )

      // G-18: opens the edit screen
      SecondaryButton(customHeight: 20, title: "Editar información", isDisabled: false) {
        showEdit = true
      }

      // G-04: opens the confirmation dialog to turn the account on or off
      SecondaryButton(
        customHeight: 20,
        title: "Cambiar estatus",
        isDisabled: false
      ) {
        showStatusDialog = true
      }
    }
  }

  // Cases tab
  private var casesTab: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text(viewModel.casesTitle)
        .font(.system(size: 18, weight: .bold))
        .foregroundColor(Color("OnBackground"))

      activeChip

      SearchBar(text: $viewModel.searchText)
        .overlay(
          RoundedRectangle(cornerRadius: 12, style: .continuous)
            .stroke(Color("InsideTextAndIcons").opacity(0.5), lineWidth: 1)
        )

      casesList
    }
    .onAppear {
      Task { await viewModel.loadCases() }
    }
  }

  // Only shows the active  cases
  private var activeChip: some View {
    Button {
      viewModel.onlyActiveCases.toggle()
    } label: {
      Text("Casos Activos")
        .font(.system(size: 15, weight: .semibold))
        .foregroundColor(viewModel.onlyActiveCases ? .white : Color("PrimaryAdax"))
        .padding(.horizontal, 18)
        .padding(.vertical, 10)
        .background(
          Capsule().fill(viewModel.onlyActiveCases ? Color("PrimaryAdax") : Color.white)
        )
        .overlay(Capsule().stroke(Color("PrimaryAdax"), lineWidth: 1.5))
    }
    .buttonStyle(.plain)
    .animation(.snappy, value: viewModel.onlyActiveCases)
  }

  @ViewBuilder
  private var casesList: some View {
    if let message = viewModel.casesErrorMessage {
      errorCard(message) {
        Task { await viewModel.loadCases(force: true) }
      }
    } else if !viewModel.hasLoadedCases {
      ProgressView()
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
    } else if viewModel.filteredCases.isEmpty {
      messageCard(
        systemImage: "folder",
        title: viewModel.cases.isEmpty ? "Sin casos asignados" : "Sin resultados",
        message: viewModel.cases.isEmpty
          ? "Cuando se le asigne un caso aparecerá aquí."
          : "Prueba con otro texto o apaga el filtro \"Casos Activos\"."
      )
    } else {
      ForEach(viewModel.filteredCases) { item in
        NavigationLink {
          CaseDetailsPage(caseId: item.id)
            .onDisappear {
              Task { await viewModel.loadCases(force: true) }
            }
        } label: {
          CollaboratorCaseCard(
            caseNumber: item.caseNumber ?? "Sin número",
            externalName: item.name.isEmpty ? "Sin nombre" : item.name,
            violenceText: viewModel.violenceText(for: item),
            stateText: viewModel.stateText(for: item),
            isOpen: item.state == "Open",
            updatedAtText: viewModel.updatedAtText(for: item)
          )
        }
        .buttonStyle(.plain)
      }
    }
  }

  private func copy(_ text: String) {
    UIPasteboard.general.string = text
    viewModel.didCopy()
  }

  private func errorCard(_ message: String, retry: @escaping () -> Void) -> some View {
    VStack(spacing: 12) {
      messageCard(
        systemImage: "exclamationmark.circle", title: "No se pudo cargar", message: message,
        iconColor: Color("Error"))

      SecondaryButton(customHeight: 20, title: "Reintentar", isDisabled: false, action: retry)
    }
  }

  private func messageCard(
    systemImage: String,
    title: String,
    message: String,
    iconColor: Color = Color("PrimaryAdax")
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
      RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color.white)
    )
  }
}

#Preview {
  NavigationStack {
    CollaboratorDetailPage(userId: "#############")
  }
  .environmentObject(AuthSession())
}
