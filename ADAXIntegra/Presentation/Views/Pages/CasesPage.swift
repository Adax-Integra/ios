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

  init(viewModel: CasesViewModel, userId: String) {
    _viewModel = StateObject(wrappedValue: viewModel)
    _newCaseViewModel = StateObject(wrappedValue: NewCaseViewModel(userId: userId))
  }

  var body: some View {
    CasesScreenTemplate {
      CasesListHeader(searchText: $viewModel.searchText, count: viewModel.filteredCases.count)

      // R-02: entry point to register a new case.
      // Disabled during the undo window so a second case cannot replace the pending one
      IconTextPrimaryButton(
        systemName: "plus",
        title: "Nuevo caso",
        isDisabled: newCaseViewModel.isShowingUndoToast
      ) {
        isShowingNewCase = true
      }
    } content: {
      CasesList(cases: viewModel.filteredCases)
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
    .fullScreenCover(isPresented: $isShowingNewCase) {
      NewCasePage(viewModel: newCaseViewModel)
    }
  }
}
