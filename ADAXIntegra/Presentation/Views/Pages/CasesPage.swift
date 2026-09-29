//
//  CasesPage.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 22/09/26.
//
import SwiftUI

struct CasesPage: View {
  @StateObject private var viewModel: CasesViewModel

  init(viewModel: CasesViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    CasesScreenTemplate {
      CasesListHeader(searchText: $viewModel.searchText, count: viewModel.filteredCases.count)
    } content: {
      CasesList(cases: viewModel.filteredCases)
    }
    .task { await viewModel.loadCases() }
  }
}
