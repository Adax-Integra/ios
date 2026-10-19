//
//  RegisterCasePage.swift
//  ADAXIntegra
//
//  Created by Lakshmi Jara on 18/10/26.
//
//  R-11: Case registration for external users
//

import SwiftUI

struct RegisterCasePage: View {
  @StateObject private var viewModel: RegisterCaseViewModel
  @Environment(\.dismiss) private var dismiss
  @State private var showExternalSupportInfo = false

  let onSaved: () -> Void

  init(externalID: String, onSaved: @escaping () -> Void) {
    _viewModel = StateObject(
      wrappedValue: RegisterCaseViewModel(externalID: externalID)
    )
    self.onSaved = onSaved
  }

  var body: some View {
    ZStack {
      Color("Background").ignoresSafeArea()

      VStack(alignment: .leading, spacing: 16) {
        PageHeader(title: "Registrar el caso") {
          dismiss()
        }

        ScrollView {
          CaseForm(
            caseDescription: $viewModel.caseDescription,
            helpDetails: $viewModel.helpDetails,
            hasExternalSupport: $viewModel.hasExternalSupport,
            caseDescriptionError: viewModel.caseDescriptionError,
            helpDetailsError: viewModel.helpDetailsError,
            onExternalSupportInfoTapped: {
              showExternalSupportInfo = true
            }
          )
          .padding(4)
        }
        .scrollDismissesKeyboard(.interactively)

        PrimaryButton(
          title: viewModel.isSaving ? "Guardando..." : "Guardar",
          isDisabled: viewModel.isSaving
        ) {
          Task {
            let saved = await viewModel.saveCase()

            if saved {
              onSaved()
              dismiss()
            }
          }
        }

        SecondaryButton(
          title: "Cancelar",
          isDisabled: viewModel.isSaving
        ) {
          dismiss()
        }
      }
      .padding(.horizontal)
    }
    .alert("Error", isPresented: $viewModel.showAlert) {
      Button("Entendido", role: .cancel) {}
    } message: {
      Text(viewModel.errorMessage)
    }
    .alert("Apoyo externo", isPresented: $showExternalSupportInfo) {
      Button("Entendido", role: .cancel) {}
    } message: {
      Text("Indica si la externa ya cuenta con un abogado o abogada que la esté apoyando.")
    }
  }
}
