//
//  CollaboratorManagementPage.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 01/10/26.
//

import SwiftUI

struct CollaboratorManagementPage: View {

  @Environment(\.dismiss) private var dismiss
  @StateObject private var viewModel = CollaboratorListViewModel()
  @State private var showAddCollaborator = false

  var body: some View {
    ZStack {
      Color("Background").ignoresSafeArea()

      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: 16) {
          PageHeader(
            title: "Gestión de Colaboradoras",
            backAction: { dismiss() },
            subtitle: "Administra las cuentas de colaboradoras"
          )

          // Opens the add collaborator page
          IconTextPrimaryButton(
            customHeight: 24,
            systemName: "plus",
            title: "Agregar colaboradora",
            isDisabled: false
          ) {
            showAddCollaborator = true
          }

          // G-06: list of collaborator accounts
          collaboratorsSection
        }
        .padding()
      }
      .refreshable { await viewModel.load() }
    }
    .navigationBarBackButtonHidden(true)
    .task { await viewModel.load() }
    // "Agregar colaboradora" is on a separate page now
    .navigationDestination(isPresented: $showAddCollaborator) {
      AddCollaboratorPage()
    }
    // Coming back from the add page reloads the list so the new account shows up
    .onChange(of: showAddCollaborator) { _, isShowing in
      if !isShowing {
        Task { await viewModel.load() }
      }
    }
  }

  private var collaboratorsSection: some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack(alignment: .firstTextBaseline) {
        Text("Colaboradoras")
          .font(.system(size: 18, weight: .bold))
          .foregroundColor(Color("OnBackground"))

        Spacer()

        if viewModel.errorMessage == nil && !viewModel.collaborators.isEmpty {
          Text("\(viewModel.countText) - más recientes primero")
            .font(.system(size: 13))
            .foregroundColor(Color("InsideTextAndIcons"))
        }
      }
      .padding(.top, 4)

      if viewModel.isLoading && viewModel.collaborators.isEmpty {
        ProgressView()
          .frame(maxWidth: .infinity)
          .padding(.vertical, 24)
      } else if let errorMessage = viewModel.errorMessage {
        errorCard(errorMessage)
      } else if viewModel.collaborators.isEmpty {
        emptyCard
      } else {
          ForEach(viewModel.collaborators) { item in
            // G-10: tapping a collaborator opens her detail
            NavigationLink {
              CollaboratorDetailPage(userId: item.id)
            } label: {
              CollaboratorCard(item: item)
            }
            .buttonStyle(.plain)
          }
      }
    }
  }

  private var emptyCard: some View {
    messageCard(
      systemImage: "person.2",
      iconColor: Color("PrimaryAdax"),
      title: "Aún no hay colaboradoras",
      message: "Cuando agregues una colaboradora aparecerá en esta lista."
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
        Task { await viewModel.load() }
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
    CollaboratorManagementPage()
  }
}
