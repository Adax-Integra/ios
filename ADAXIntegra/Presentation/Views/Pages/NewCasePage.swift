//
//  NewCasePage.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 23/09/26.
//

import SwiftUI

// Page for HU R-02: an "externa" registers the details of her case
// It only captures and confirms the case; CasesPage owns the ViewModel and
// shows the undo toast after this page closes
struct NewCasePage: View {
  // Observed and not owned, CasesPage creates it and keeps it alive after this page closes
  @ObservedObject var viewModel: NewCaseViewModel
  @Environment(\.dismiss) private var dismiss

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
          .padding(4)
        }
        .scrollDismissesKeyboard(.interactively)
        PrimaryButton(title: "Crear caso", isDisabled: !viewModel.isFormValid) {
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
            onConfirm: {
              viewModel.onConfirm()
              dismiss()
            },
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
  // Preview-only repository: returns fake data without calling the backend
  private struct PreviewCaseRepository: CaseRepository {
    func getCases(for userId: String) async throws -> [Case] {
      []
    }

    func createCase(_ newCase: NewCase, userId: String) async -> String? {
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
