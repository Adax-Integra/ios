//
//  CasesPage.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 22/09/26.
//
import SwiftUI

struct CasesPage: View {
    @StateObject private var viewModel: CasesViewModel

    init(viewModel: CasesViewModel = CasesViewModel(
        repository: RemoteCaseRepository(),
        userId: "c4d665c3-56b7-4616-b322-69d3ffa261d4")
    ) {
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
