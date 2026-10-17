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

  init(userId: String) {
    _viewModel = StateObject(wrappedValue: CollaboratorDetailViewModel(userId: userId))
  }

  var body: some View {
    ZStack {
      Color("Background").ignoresSafeArea()

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
      }
    }
    .toolbar(.hidden, for: .navigationBar)
    .task { await viewModel.load() }
    .onChange(of: viewModel.selectedTab) { _, tab in
      if tab == .cases {
        Task { await viewModel.loadCases() }
      }
    }
    .toast(isPresented: $viewModel.isShowingCopiedToast, message: "Copiado al portapapeles")
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

      SecondaryButton(customHeight: 20, title: "Editar información", isDisabled: false) {}
    }
  }

  // Cases tab

  private var casesTab: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text(viewModel.casesTitle)
        .font(.system(size: 18, weight: .bold))
        .foregroundColor(Color("OnBackground"))

      activeChip
      searchField
      casesList
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

  private var searchField: some View {
    HStack(spacing: 10) {
      Image(systemName: "magnifyingglass")
        .foregroundColor(Color("InsideTextAndIcons"))

      TextField("Buscar por número o nombre", text: $viewModel.searchText)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()

      if !viewModel.searchText.isEmpty {
        Button {
          viewModel.searchText = ""
        } label: {
          Image(systemName: "xmark.circle.fill")
            .foregroundColor(Color("InsideTextAndIcons"))
        }
        .buttonStyle(.plain)
      }
    }
    .padding(.horizontal, 14)
    .padding(.vertical, 12)
    .background(
      RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color.white)
    )
    .overlay(
      RoundedRectangle(cornerRadius: 12, style: .continuous)
        .stroke(Color("InsideTextAndIcons").opacity(0.5), lineWidth: 1)
    )
  }

  @ViewBuilder
  private var casesList: some View {
    if let message = viewModel.casesErrorMessage {
      errorCard(message) {
        Task { await viewModel.loadCases() }
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
               // We make use of the V-11 get case Details to load the detials of the case assigned to a internal
                NavigationLink {
                  CaseDetailsPage(caseId: item.id)
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
    CollaboratorDetailPage(userId: "130ebfd0-313e-446b-ae7e-970ed4624169")
  }
}
