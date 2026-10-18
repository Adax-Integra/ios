//
//  MyCasesViewModel.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 17/10/26.
//

import Combine
import Foundation

// V-12: list of the cases assigned to the logged-in collaborator
@MainActor
final class MyCasesViewModel: ObservableObject {
  @Published var cases: [CaseListItem] = []
  @Published var total = 0
  @Published var isLoading = false
  @Published var errorMessage: String?
  @Published var searchText = ""
  @Published var urgencyFilter = "Todas"

  let urgencyOptions = ["Todas", "Alta", "Media", "Baja", "Sin evaluar"]

  var listAssignedCasesUseCase: ListAssignedCasesUseCaseProtocol
  // Only the answer of the last request is shown while the user types
  private var latestRequestID = 0

  init(listAssignedCasesUseCase: ListAssignedCasesUseCaseProtocol? = nil) {
    // Built here so it runs on the main actor, same as other ViewModels
    self.listAssignedCasesUseCase =
      listAssignedCasesUseCase
      ?? ListAssignedCasesUseCase(repository: RemoteCaseListRepository())
  }

  func loadCases() async {
    latestRequestID += 1
    let requestID = latestRequestID

    isLoading = true
    errorMessage = nil

    do {
      let result = try await listAssignedCasesUseCase.execute(
        page: 1,
        limit: 20,
        search: searchText.trimmingCharacters(in: .whitespaces),
        urgency: urgencyFilter
      )

      guard requestID == latestRequestID else { return }
      cases = result.cases
      total = result.total
    } catch {
      guard requestID == latestRequestID else { return }
      errorMessage = "No se pudieron cargar tus casos."
    }

    isLoading = false
  }
}
