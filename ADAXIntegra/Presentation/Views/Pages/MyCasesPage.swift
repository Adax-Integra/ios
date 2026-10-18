//
//  MyCasesPage.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 17/10/26.
//

import SwiftUI

// V-12: "Mis Casos", the cases assigned to the logged-in collaborator
struct MyCasesPage: View {
  @Environment(\.dismiss) private var dismiss
  @StateObject private var viewModel = MyCasesViewModel()

  var body: some View {
    ListPageTemplate {
      PageHeader(title: "Mis Casos", backAction: { dismiss() })
    } toolbar: {
      CaseListToolbar(
        searchText: $viewModel.searchText,
        selectedFilter: $viewModel.urgencyFilter,
        totalCases: viewModel.total,
        filterOptions: viewModel.urgencyOptions
      )
    } content: {
      if viewModel.isLoading && viewModel.cases.isEmpty {
        ProgressView()
          .frame(maxWidth: .infinity)
          .padding()
      } else if let error = viewModel.errorMessage {
        Text(error)
          .foregroundStyle(.secondary)
          .padding()
      } else if viewModel.cases.isEmpty {
        Text("No tienes casos asignados")
          .foregroundStyle(.secondary)
          .padding()
      } else {
        ForEach(viewModel.cases) { item in
          NavigationLink {
            CaseDetailsPage(caseId: item.id)
          } label: {
            CaseCardInterna(
              caseNumber: item.displayCaseNumber,
              name: item.displayName,
              urgency: item.urgency,
              violenceTypes: item.violenceTypes,
              assignedTo: item.assignedNames,
              caseId: item.id
            )
          }
          .buttonStyle(.plain)
        }
      }
    }
    .navigationBarBackButtonHidden(true)
    .refreshable {
      await viewModel.loadCases()
    }
    // Hides the keyboard of the search bar
    .onTapGesture {
      UIApplication.shared.sendAction(
        #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil
      )
    }
    // Reloads when the search or the filter changes, waiting a little while the user types
    .task(id: "\(viewModel.searchText)|\(viewModel.urgencyFilter)") {
      try? await Task.sleep(for: .milliseconds(300))
      guard !Task.isCancelled else { return }
      await viewModel.loadCases()
    }
  }
}

#Preview {
  MyCasesPage()
}
