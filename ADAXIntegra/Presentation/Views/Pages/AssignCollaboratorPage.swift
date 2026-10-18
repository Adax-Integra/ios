//
//  AssignCollaboratorPage.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 17/10/26.
//

import SwiftUI

struct AssignCollaboratorPage: View {
  let caseNumber: String
  // Called with the ids of every assigned collaborator after the backend saves them
  var onAssigned: (Set<String>) -> Void = { _ in }

  @StateObject private var viewModel: AssignCollaboratorViewModel
  @Environment(\.dismiss) private var dismiss

  // assignedIds are the collaborators already saved, they start selected
  init(
    caseId: String,
    caseNumber: String,
    assignedIds: Set<String> = [],
    onAssigned: @escaping (Set<String>) -> Void = { _ in }
  ) {
    self.caseNumber = caseNumber
    self.onAssigned = onAssigned
    _viewModel = StateObject(
      wrappedValue: AssignCollaboratorViewModel(caseId: caseId, assignedIds: assignedIds)
    )
  }

  var body: some View {
    VStack(spacing: 0) {
      VStack(alignment: .leading, spacing: 16) {
        // Same subtitle style as PageHeader, the native bar only has the title
        Text("Caso \(caseNumber)")
          .font(.subheadline)
          .foregroundColor(Color("OnBackground").opacity(0.7))

        SearchBarInterna(placeholder: "Buscar por nombre", text: $viewModel.searchText)
      }
      .padding(.horizontal, 16)
      .padding(.top, 16)
      .padding(.bottom, 8)

      ScrollView(showsIndicators: false) {
        collaboratorsSection
          .padding(.horizontal, 16)
          .padding(.vertical, 8)
      }
      .refreshable { await viewModel.load() }

      // Pinned to the bottom like the actions of the case detail
      VStack(spacing: 8) {
        if let assignError = viewModel.assignError {
          FieldErrorLabel(assignError)
            .frame(maxWidth: .infinity, alignment: .leading)
        }

        PrimaryButton(
          customHeight: 23,
          title: assignButtonTitle,
          isDisabled: !viewModel.canAssign,
          action: {
            Task {
              if await viewModel.assign() {
                onAssigned(viewModel.selectedIds)
                dismiss()
              }
            }
          }
        )
      }
      .padding(16)
    }
    .background(Color("Background").ignoresSafeArea())
    .navigationTitle("Asignar colaboradoras")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar(.visible, for: .navigationBar)
    .task { await viewModel.load() }
  }

  private var assignButtonTitle: String {
    if viewModel.isAssigning { return "Asignando..." }
    let count = viewModel.newIds.count
    return count == 0 ? "Asignar" : "Asignar (\(count))"
  }

  @ViewBuilder
  private var collaboratorsSection: some View {
    VStack(alignment: .leading, spacing: 10) {
      if viewModel.isLoading && viewModel.collaborators.isEmpty {
        ProgressView()
          .frame(maxWidth: .infinity)
          .padding(.vertical, 24)
      } else if let errorMessage = viewModel.errorMessage {
        VStack(spacing: 12) {
          messageCard(
            systemImage: "exclamationmark.circle",
            iconColor: Color("Error"),
            title: "No se pudo cargar la lista",
            message: errorMessage
          )

          SecondaryButton(customHeight: 20, title: "Reintentar", isDisabled: viewModel.isLoading) {
            Task { await viewModel.load() }
          }
        }
      } else if viewModel.filteredCollaborators.isEmpty {
        messageCard(
          systemImage: "person.2",
          iconColor: Color("PrimaryAdax"),
          title: viewModel.collaborators.isEmpty
            ? "No hay colaboradoras activas" : "Sin resultados",
          message: viewModel.collaborators.isEmpty
            ? "Cuando haya colaboradoras activas aparecerán en esta lista."
            : "Ninguna colaboradora coincide con la búsqueda."
        )
      } else {
        ForEach(viewModel.filteredCollaborators) { item in
          Button {
            viewModel.toggle(item)
          } label: {
            AssignableCollaboratorCard(
              item: item,
              isSelected: viewModel.isSelected(item),
              isAssigned: viewModel.isAssigned(item)
            )
          }
          .buttonStyle(.plain)
        }
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
    AssignCollaboratorPage(caseId: "8c097b2f-5418-45ba-ab5f-9fc866fbe778", caseNumber: "C-0001")
  }
}
