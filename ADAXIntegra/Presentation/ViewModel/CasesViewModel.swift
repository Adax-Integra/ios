//
//  CasesViewModel.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 22/09/26.
//

import Foundation
import Combine

final class CasesViewModel: ObservableObject {
    @Published var cases: [Case] = []
    @Published var searchText: String = ""

    private let repository: CaseRepository

    init(repository: CaseRepository) { self.repository = repository }

    var filteredCases: [Case] {
        searchText.isEmpty ? cases : cases.filter { $0.description.localizedCaseInsensitiveContains(searchText) }
    }

    func loadCases() async {
        do { cases = try await repository.getCases(for: UUID()) } catch { cases = [] }
    }
}
