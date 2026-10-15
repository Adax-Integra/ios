//
//  CaseProgressPage.swift
//  ADAXIntegra
//
//  Created by Lakshmi Jara on 15/10/26.
//

import SwiftUI

struct CaseProgressPage: View {
  @StateObject private var viewModel: CaseProgressViewModel
  let onBack: () -> Void

  init(
    caseId: String,
    onBack: @escaping () -> Void
  ) {
    _viewModel = StateObject(
      wrappedValue: CaseProgressViewModel(
        repository: RemoteCaseRepository(),
        caseId: caseId
      )
    )
    self.onBack = onBack
  }

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 28) {
        HStack(alignment: .top, spacing: 16) {
          Button(action: onBack) {
            Image(systemName: "chevron.left")
              .font(.title3)
              .foregroundStyle(Color("PrimaryAdax"))
              .frame(width: 44, height: 44)
          }
          .accessibilityLabel("Volver a mis casos")

          VStack(alignment: .leading, spacing: 6) {
            Text("Progreso del caso")
              .font(.title2.bold())

            if viewModel.caseDetail != nil {
              Text("ID: \(viewModel.caseNumberText)")
                .font(.subheadline)
            }
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
