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
    @Published var errorMessage: String?
    
    private let repository: CaseRepository
    private let userId: String

    init(repository: CaseRepository, userId: String) {
        self.repository = repository
        self.userId = userId
    }

    var filteredCases: [Case] {
        searchText.isEmpty ? cases : cases.filter { ($0.writtenDescription ?? "" ).localizedCaseInsensitiveContains(searchText) }
    }

    func loadCases() async {
        do {
            cases = try await repository.getCases(for: userId)
        } catch {
            cases = []
            errorMessage = "No se pudieron cargar los casos."
        }
    }
}
