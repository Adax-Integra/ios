//
//  ExpedientesPage.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 23/09/26.
//

import SwiftUI

struct CasesPageInterna: View {
  @Environment(\.dismiss) private var dismiss
  @StateObject private var viewModel = CasesViewModelInterna()

  var body: some View {
    ListPageTemplate {
      PageHeader(title: "Casos", backAction: { dismiss() })
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
        Text("No hay expedientes")
          .foregroundStyle(.secondary)
          .padding()
      } else {
        ForEach(viewModel.cases) { item in
          CaseCardInterna(
            name: item.displayName,
            urgency: item.urgency,
            state: item.stateText,
            updateAt: item.updatedDate,
            categories: item.violenceTypes
          )
        }
      }
    }
    .navigationBarBackButtonHidden(true)
    // vuelve a cargar la pestaña cuando se cambia la busqueda o el filtro
    .task(id: "\(viewModel.searchText)|\(viewModel.urgencyFilter)") {
      try? await Task.sleep(for: .milliseconds(300))
      guard !Task.isCancelled else { return }
      await viewModel.loadCases()
    }
  }
}

#Preview {
  CasesPageInterna()
}
