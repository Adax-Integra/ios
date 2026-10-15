//
//  CaseProgressViewModel.swift
//  ADAXIntegra
//
//  Created by Lakshmi Jara on 15/10/26.
//

import Combine
import Foundation

// keeps published UI updates on the main actor
@MainActor
final class CaseProgressViewModel: ObservableObject {
  @Published var caseDetail: CaseDetail?
  @Published var isLoading = false
  @Published var errorMessage: String?

  private let getCaseDetailUseCase: GetCaseDetailUseCaseProtocol
  private let caseId: String

  // reuses the existing detail use case with an injected repository
  init(repository: CaseRepository, caseId: String) {
    self.getCaseDetailUseCase = GetCaseDetailUseCase(
      repository: repository
    )
    self.caseId = caseId
  }

  // orders the timeline
  var steps: [CaseDetailStep] {
    (caseDetail?.steps ?? []).sorted {
      ($0.stepNumber ?? Int.max) < ($1.stepNumber ?? Int.max)
    }
  }

  var caseNumberText: String {
    caseDetail?.caseNumber ?? caseId
  }

  func loadCase() async {
    guard !isLoading else { return }

    isLoading = true
    errorMessage = nil

    defer { isLoading = false }

    do {
      let detail = try await getCaseDetailUseCase.execute(
        caseId: caseId
      )

      // avoids publishing a response after the loading task is cancelled
      guard !Task.isCancelled else { return }
      caseDetail = detail
    } catch {
      guard !Task.isCancelled else { return }

      errorMessage = "No se pudo cargar el progreso del caso."
    }
  }
}
