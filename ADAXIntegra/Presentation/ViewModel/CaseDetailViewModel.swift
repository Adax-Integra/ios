//
//  CaseDetailViewModel.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 02/10/26.
//
//  ViewModel for US V-11  case detail screen and close case action
//

import Combine
import Foundation

// we make sure that the UI updates happen ina safety environment on the mai thread
@MainActor
final class CaseDetailViewModel: ObservableObject {
  //Published Properties (UI State) (case detail holds the full casedetails to display, is loading indicates
  //wheter the data is being fetched and error Message stores various error messages to show feedback on UI, as well as the toast molecule to express a message of succes or error
  @Published var caseDetail: CaseDetail?
  @Published var isLoading = false
  @Published var errorMessage: String?
  @Published var showToast = false
  @Published var toastMessage = ""

  private let caseId: String
  private let getCaseDetailUseCase: GetCaseDetailUseCaseProtocol
  private let closeCaseUseCase: CloseCaseUseCaseProtocol

  // Initializes the view model with a case ID and dependencies
  init(
    caseId: String,
    repository: CaseRepository = RemoteCaseRepository()
  ) {
    self.caseId = caseId
    self.getCaseDetailUseCase = GetCaseDetailUseCase(repository: repository)
    self.closeCaseUseCase = CloseCaseUseCase(repository: repository)
  }
  // Asynchronously fetches case details and updates UI state variables
  func loadCase() async {
    isLoading = true
    errorMessage = nil
    do {
      caseDetail = try await getCaseDetailUseCase.execute(caseId: caseId)
    } catch {
      errorMessage = "No se pudo cargar el detalle del caso."
    }
    isLoading = false
  }
  // Triggers the process to close the case
  func closeCase() async {
    do {
      let success = try await closeCaseUseCase.execute(caseId: caseId)
      if success {
        toastMessage = "El caso se cerró correctamente."
        showToast = true
        await loadCase()
      }
    } catch {
      toastMessage = "No se pudo cerrar el caso. Es posible que ya esté cerrado."
      showToast = true
    }
  }
}
