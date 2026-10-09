//
//  CasesPage.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 22/09/26.
//
import SwiftUI

struct CasesPage: View {
  @StateObject private var viewModel: CasesViewModel
  // R-02: Owned here and not by NewCasePage so the confirmed case survives after "Nuevo Caso"
  // closes and the undo toast can be shown on this list
  @StateObject private var newCaseViewModel: NewCaseViewModel
  @State private var isShowingNewCase = false
  // R-01: the user reviews the preSubmission before creating a case
  @State private var isShowingPreSubmission = false
  // Set when the review finishes, so "Nuevo caso" opens once the review has closed
  @State private var shouldOpenNewCase = false
  private let userId: String
  private let countryRepository = CachedCountryRepository(remote: RemoteCountryRepository())

  init(viewModel: CasesViewModel, userId: String) {
    self.userId = userId
    _viewModel = StateObject(wrappedValue: viewModel)
    _newCaseViewModel = StateObject(wrappedValue: NewCaseViewModel(userId: userId))
  }

  var body: some View {
    CasesScreenTemplate {
      CasesListHeader(searchText: $viewModel.searchText, count: viewModel.filteredCases.count)
    } content: {
      CasesList(cases: viewModel.filteredCases)
      // Extra space so the last case can scroll above the floating button
      Color.clear.frame(height: 126)
    }
    .refreshable {
      await viewModel.loadCases()
    }
    // R-02: stays fixed in the bottom-right corner while the list scrolls.
    // Hidden during the undo window so a second case cannot replace the pending one
    .overlay(alignment: .bottomTrailing) {
      if !newCaseViewModel.isShowingUndoToast {
        FloatingActionButton(systemName: "plus", accessibilityLabel: "Nuevo caso") {
          isShowingPreSubmission = true
        }
        .padding(.trailing, 16)
        .padding(.bottom, 70)
      }
    }
    // R-02: undo window shown on the list after "Nuevo caso" closes
    .toast(
      isPresented: $newCaseViewModel.isShowingUndoToast,
      message: "Caso creado",
      actionTitle: "Deshacer"
    ) {
      newCaseViewModel.onUndo()
    }
    // When the undo window closes, sends the case (if not undone) and refreshes the list
    .onChange(of: newCaseViewModel.isShowingUndoToast) { _, isShowing in
      if !isShowing {
        Task {
          await newCaseViewModel.sendPendingCase()
          await viewModel.loadCases()
        }
      }
    }
    // If the user switches tabs during the undo window, the confirmed case is still sent
    .onDisappear {
      Task { await newCaseViewModel.sendPendingCase() }
    }
    .alert("Algo salió mal", isPresented: $newCaseViewModel.showAlert) {
      Button("Entendido", role: .cancel) {}
    } message: {
      Text(newCaseViewModel.messageAlert)
    }
    .task { await viewModel.loadCases() }
    /*
     R-01: first the user confirms or edits the preSubmission,
     then "Nuevo caso" opens.
    */
    .fullScreenCover(
      isPresented: $isShowingPreSubmission,
      onDismiss: {
        guard shouldOpenNewCase else { return }
        shouldOpenNewCase = false
        isShowingNewCase = true
      }
    ) {
      PreSubmissionPage(
        viewModel: PreSubmissionViewModel(
          repository: RemotePreSubmissionRepository(),
          countryRepository: countryRepository,
          userId: userId,
          onFinish: {
            shouldOpenNewCase = true
            isShowingPreSubmission = false
          }
        ),
        onBack: { isShowingPreSubmission = false }
      )
    }
    .fullScreenCover(isPresented: $isShowingNewCase) {
      NewCasePage(viewModel: newCaseViewModel)
    }
  }
}
