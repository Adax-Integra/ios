//
//  NewCasePage.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 23/09/26.
//

import SwiftUI

// Page for HU R-02: an "externa" registers the details of her case
struct NewCasePage: View {
  @StateObject private var viewModel: NewCaseViewModel
  @Environment(\.dismiss) private var dismiss

  init(viewModel: NewCaseViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    ZStack {
      Color("Background").ignoresSafeArea()

      VStack(alignment: .leading, spacing: 16) {
        PageHeader(title: "Nuevo Caso") { dismiss() }

        ScrollView {
          CaseForm(
            caseDescription: $viewModel.caseDescription,
            helpDetails: $viewModel.helpDetails,
            hasExternalSupport: $viewModel.hasExternalSupport,
            onExternalSupportInfoTapped: { viewModel.isShowingExternalSupportInfo = true }
          )
          .padding(.vertical, 4)
        }
        .scrollDismissesKeyboard(.interactively)
        // Attached to the ScrollView so the toast appears above the button, not on top of it
        .toast(
          isPresented: $viewModel.isShowingUndoToast,
          message: "Caso creado",
          actionTitle: "Deshacer"
        ) {
          viewModel.onUndo()
        }

        PrimaryButton(
          title: "Crear caso", isDisabled: !viewModel.isFormValid || viewModel.isShowingUndoToast
        ) {
          dismissKeyboard()
          viewModel.onCreateTapped()
        }
      }
      .padding(.horizontal)

      if viewModel.isShowingConfirmation {
        confirmationDialog
      }
    }
    .animation(.snappy, value: viewModel.isShowingConfirmation)
    .alert("Apoyo externo", isPresented: $viewModel.isShowingExternalSupportInfo) {
      Button("Entendido", role: .cancel) {}
    } message: {
      Text("Indica si es que ya cuentas con una abogado/a que te esté apoyando.")
    }
    // When the undo window closes, the View tells the ViewModel to send the case.
    // If the user tapped "Deshacer", pendingCase is already nil and nothing is sent
    .onChange(of: viewModel.isShowingUndoToast) { _, isShowing in
      if !isShowing {
        Task { await viewModel.sendPendingCase() }
      }
    }
    // If the user leaves during the undo window, the confirmed case is still sent
    .onDisappear {
      Task { await viewModel.sendPendingCase() }
    }
    .alert("Algo salió mal", isPresented: $viewModel.showAlert) {
      Button("Entendido", role: .cancel) {}
    } message: {
      Text(viewModel.messageAlert)
    }
  }

  // Removes focus from the active text field, closing the keyboard and any
  // autocorrection suggestion that would float above the confirmation dialog
  private func dismissKeyboard() {
    UIApplication.shared.sendAction(
      #selector(UIResponder.resignFirstResponder),
      to: nil,
      from: nil,
      for: nil
    )
  }

  private var confirmationDialog: some View {
    ZStack {
      Color.black.opacity(0.4)
        .ignoresSafeArea()
        .onTapGesture { viewModel.isShowingConfirmation = false }

      SurfaceCard {
        VStack(spacing: 8) {
          Text("Registrar caso nuevo")
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(Color("OnBackground"))

          ConfirmationActions(
            prompt: "¿Estás de acuerdo que todos los datos son correctos?",
            onConfirm: { viewModel.onConfirm() },
            onDismiss: { viewModel.isShowingConfirmation = false },
            confirmTitle: "Confirmar",
            dismissTitle: "Cancelar"
          )
        }
        .padding(24)
      }
      .padding(.horizontal, 24)
      .transition(.scale(scale: 0.95).combined(with: .opacity))
    }
  }
}

#if DEBUG
  private class PreviewCaseRepository: CaseRepositoryP {
    func createCase(_ newCase: CaseEntity, userId: String) async -> String? {
      UUID().uuidString
    }
  }

  #Preview {
    NewCasePage(
      viewModel: NewCaseViewModel(
        userId: "preview-user",
        createCaseUseCase: CreateCaseUseCase(dataRepository: PreviewCaseRepository())
      )
    )
  }
#endif
