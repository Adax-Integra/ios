//
//  ExpedientesViewModel.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 24/09/26.
//

import Combine
import Foundation

@MainActor
final class ExpedientesViewModel: ObservableObject {
  @Published var cases: [CaseListItem] = []
  @Published var total = 0
  @Published var isLoading = false
  @Published var errorMessage: String?
  @Published var searchText = ""
  @Published var urgencyFilter = "Todas"

  let urgencyOptions = ["Todas", "Alta", "Media", "Baja", "Sin evaluar"]

  private let repository: CaseListRepository

  init(repository: CaseListRepository = RemoteCaseListRepository()) {
    self.repository = repository
  }

  func loadCases() async {
    isLoading = true
    errorMessage = nil

    do {
      let result = try await repository.listCases(
        page: 1, limit: 20, search: searchText.trimmingCharacters(in: .whitespaces),
        urgency: urgencyFilter
      )
      guard !Task.isCancelled else { return }
      cases = result.cases
      total = result.total
    } catch {
      guard !Task.isCancelled else { return }
      errorMessage = "No se pudieron cargar los expedientes."
      print("Error al cargar los expedientes", error)
    }

    isLoading = false
  }
}
