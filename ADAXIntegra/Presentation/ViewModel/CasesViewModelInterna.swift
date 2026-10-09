//
//  ExpedientesViewModel.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 24/09/26.
//

import Combine
import Foundation

@MainActor
final class CasesViewModelInterna: ObservableObject {
  @Published var cases: [CaseListItem] = []
  @Published var total = 0
  @Published var isLoading = false
  @Published var errorMessage: String?
  @Published var searchText = ""
  @Published var urgencyFilter = "Todas"

  let urgencyOptions = ["Todas", "Alta", "Media", "Baja", "Sin evaluar"]

  private let repository: CaseListRepository
  private var latestRequestID = 0

  init(repository: CaseListRepository = RemoteCaseListRepository()) {
    self.repository = repository
  }

  func loadCases() async {
    latestRequestID += 1
    let requestID = latestRequestID

    isLoading = true
    errorMessage = nil

    defer {
      if requestID == latestRequestID {
        isLoading = false
      }
    }

    do {
      let result = try await repository.listCases(
        page: 1, limit: 20, search: searchText.trimmingCharacters(in: .whitespaces),
        urgency: urgencyFilter
      )

      guard requestID == latestRequestID else { return }
      cases = result.cases
      total = result.total
    } catch {
      guard requestID == latestRequestID else { return }
      errorMessage = "No se pudieron cargar los expedientes."
      print("Error al cargar los expedientes", error)
    }

    isLoading = false
  }
}
