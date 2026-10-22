//
//  CasesViewModel.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 22/09/26.
//

import Combine
import Foundation

final class CasesViewModel: ObservableObject {
  @Published var cases: [Case] = []
  @Published var searchText: String = "" {
    didSet { visibleCount = Self.pageSize }
  }
  @Published var errorMessage: String?
  @Published private var visibleCount = CasesViewModel.pageSize

  private static let pageSize = 10
  private let repository: CaseRepository
  private let userId: String

  init(repository: CaseRepository, userId: String) {
    self.repository = repository
    self.userId = userId
  }

  private var matchingCases: [Case] {
    guard !searchText.isEmpty else { return cases }
    return cases.filter { item in
      (item.caseNumber ?? "").localizedCaseInsensitiveContains(searchText)
        || item.violenceTypes.contains { $0.localizedCaseInsensitiveContains(searchText) }
    }
  }

  var filteredCases: [Case] {
    Array(matchingCases.prefix(visibleCount))
  }

  var totalCount: Int { matchingCases.count }

  // returns the most recently updated active case for the home screen
  var latestCase: Case? {
    cases
      .sorted {
        ($0.updatedAtDate ?? .distantPast) > ($1.updatedAtDate ?? .distantPast)
      }
      .first
  }

  func loadMore() {
    guard visibleCount < matchingCases.count else { return }
    visibleCount += Self.pageSize
  }

  func loadCases() async {
    do {
      cases = try await repository.getCases(for: userId)
      visibleCount = Self.pageSize
      errorMessage = nil
    } catch {
      cases = []
      errorMessage = "No se pudieron cargar los casos."
    }
  }
}
