//
//  ExpedientesPage.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 23/09/26.
//

import SwiftUI

struct CasesPageInterna: View {
  @StateObject private var viewModel = CasesViewModelInterna()

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
        Text("No hay casos disponibles")
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
    .navigationTitle("Casos")
    // pull down the list to reload
    .refreshable {
      await viewModel.loadCases()
    }

    // vuelve a cargar la pestaña cuando se cambia la busqueda o el filtro
    .task(id: "\(viewModel.searchText)|\(viewModel.urgencyFilter)") {
      try? await Task.sleep(for: .milliseconds(300))
      guard !Task.isCancelled else { return }
      await viewModel.loadCases()
    }
  }
}

#Preview {
  NavigationStack {
    CasesPageInterna()
  }
}
