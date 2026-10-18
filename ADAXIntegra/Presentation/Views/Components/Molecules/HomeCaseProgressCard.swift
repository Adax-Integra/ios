//
//  HomeCaseProgressCard.swift
//  ADAXIntegra
//
//  Created by Lakshmi Jara on 17/10/26.
//

import SwiftUI

// displays the active case progress on the external home screen
struct HomeCaseProgressCard: View {
  let caseId: String

  @StateObject private var viewModel: CaseProgressViewModel

  init(caseId: String) {
    self.caseId = caseId
    _viewModel = StateObject(
      wrappedValue: CaseProgressViewModel(
        repository: RemoteCaseRepository(),
        caseId: caseId
      )
    )
  }

  var body: some View {
    SurfaceCard(cornerRadius: 28) {
      VStack(alignment: .leading, spacing: 16) {
        HStack {
          Text("Tu caso en curso")
            .font(.headline)
            .foregroundColor(Color("OnBackground"))

          Spacer()

          NavigationLink {
            CaseProgressPage(caseId: caseId)
          } label: {
            HStack(spacing: 6) {
              Text("Ver detalles")
              Image(systemName: "chevron.right")
            }
            .font(.subheadline.bold())
            .foregroundColor(Color("PrimaryAdax"))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color("PrimaryAdax").opacity(0.08))
            .clipShape(Capsule())
          }
        }

        if viewModel.isLoading && viewModel.caseDetail == nil {
          ProgressView("Cargando progreso...")
        } else if let message = viewModel.errorMessage {
          Text(message)
            .font(.subheadline)
        } else if viewModel.caseDetail != nil {
          if viewModel.steps.isEmpty {
            Text("Este caso todavía no tiene pasos registrados.")
              .font(.subheadline)
          } else {
            HomeCaseProgressTimeline(steps: viewModel.steps)
          }
        }
      }
      .padding(20)
    }
    .task {
      await viewModel.loadCase()
    }
  }
}
