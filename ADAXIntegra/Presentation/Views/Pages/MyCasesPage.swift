//
//  MyCasesPage.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 17/10/26.
//

import SwiftUI

// V-12: "Mis Casos", the cases assigned to the logged-in collaborator
struct MyCasesPage: View {
  @StateObject private var viewModel = MyCasesViewModel()

  var body: some View {
    ListPageTemplate {
      EmptyView()
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
            // same card as the record detail so the case lists look the same
            RecordCaseDetail(
              caseId: item.displayCaseNumber,
              externalName: item.displayName,
              urgencyType: item.urgencyType ?? .sinEvaluar,
              violenceType: item.violenceTypes.joined(separator: ", "),
              internalAssigned: item.assignedNames.joined(separator: ", "),
              lastUpdated: item.updatedDate?.dateString ?? "—"
            )
          }
          .buttonStyle(.plain)
        }
      }
    }
    .navigationTitle("Mis Casos")
    .refreshable {
      await viewModel.loadCases()
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
  NavigationStack {
    MyCasesPage()
  }
}
