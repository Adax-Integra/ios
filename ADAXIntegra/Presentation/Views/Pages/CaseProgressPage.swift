//
//  CaseProgressPage.swift
//  ADAXIntegra
//
//  Created by Lakshmi Jara on 15/10/26.
//

import SwiftUI

struct CaseProgressPage: View {
  @StateObject private var viewModel: CaseProgressViewModel

  init(caseId: String) {
    _viewModel = StateObject(
      wrappedValue: CaseProgressViewModel(
        repository: RemoteCaseRepository(),
        caseId: caseId
      )
    )
  }

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 28) {
        VStack(alignment: .leading, spacing: 6) {
          Text("Progreso del caso")
            .font(.title2.bold())

          if viewModel.caseDetail != nil {
            Text("ID: \(viewModel.caseNumberText)")
              .font(.subheadline)
          }
        }

        if viewModel.isLoading && viewModel.caseDetail == nil {
          ProgressView("Cargando caso...")
            .frame(maxWidth: .infinity)
        }

        if let message = viewModel.errorMessage {
          VStack(spacing: 12) {
            Text(message)

            Button("Reintentar") {
              Task {
                await viewModel.loadCase()
              }
            }
            .disabled(viewModel.isLoading)
          }
          .frame(maxWidth: .infinity)
        }

        if viewModel.caseDetail != nil {
          VStack(spacing: 16) {
            if let description = viewModel.descriptionText {
              CaseDescriptionCard(description: description)
            }

            if let help = viewModel.helpText {
              CaseHelpWanted(helpwanted: help, title: "Ayuda requerida")
            }
          }

          if viewModel.steps.isEmpty {
            Text("Este caso todavía no tiene pasos registrados.")
              .foregroundStyle(.secondary)
          } else {
            CaseProgressTimeline(steps: viewModel.steps)
          }
        }
      }
      .padding(24)
    }
    .background(Color("BackgroundColor").ignoresSafeArea())
    .task {
      await viewModel.loadCase()
    }
    .refreshable {
      await viewModel.loadCase()
    }
  }
}
