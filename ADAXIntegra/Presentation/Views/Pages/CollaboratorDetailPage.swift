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
      .refreshable {
              await viewModel.load()
              if viewModel.selectedTab == .cases {
                await viewModel.loadCases()
              }
            }
    }
      
    .toolbar(.hidden, for: .navigationBar)
    .task { await viewModel.load() }
    
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
          
          // fix thkns to a teammate that pointed outi could re use the molecule of seachBar
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
                NavigationLink {
                  CaseDetailsPage(caseId: item.id)
                    .onDisappear {
                      Task { await viewModel.loadCases() }
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
}
