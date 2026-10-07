//
//  CaseDetailsPage.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 02/10/26.
//
// General page for US v-11 Get Case details, where an internal user can see de details of a particular case and may close the case

import SwiftUI

struct CaseDetailsPage: View {
  let caseId: String

  // Observed ViewModel managing UI state and  logic
  @StateObject private var viewModel: CaseDetailViewModel

  @State private var showCloseModal = false
  @Environment(\.dismiss) private var dismiss

  init(caseId: String) {
    self.caseId = caseId
    _viewModel = StateObject(wrappedValue: CaseDetailViewModel(caseId: caseId))
  }
  //Assigns the backend status string ("Open", "Closed") to the  display text that is in Español (Abierto, Cerrado)
  private var statusText: String {
    switch viewModel.caseDetail?.state {
    case "Open": return "Abierto"
    case "Closed": return "Cerrado"
    default: return "—"
    }
  }

  private var userFullName: String {
    let parts = [viewModel.caseDetail?.user.name, viewModel.caseDetail?.user.lastName]
      .compactMap { $0 }
    return parts.isEmpty ? "—" : parts.joined(separator: " ")
  }

  var body: some View {

    // Main page structure using  template view
    ZStack {
      CaseDetailsTemplate(
        caseNumber: viewModel.caseDetail?.caseNumber ?? "—",
        status: statusText,
        onBack: {
          dismiss()
        },
        content: {
          RecordCaseSummary(
            userName: userFullName,
            recordId: viewModel.caseDetail?.recordId ?? "—",
            lastModified: viewModel.caseDetail?.updatedAt ?? "—",
            createdAt: viewModel.caseDetail?.createdAt ?? "—",
            onEditTapped: { print("Edit tapped") }
          )

          CaseInfoCard(
            hasLawyer: viewModel.caseDetail?.hasLawyer ?? false
          )

          CaseDescriptionCard(
            description: viewModel.caseDetail?.writtenDescription ?? ""
          )
          CaseHelpWanted(
            helpwanted: viewModel.caseDetail?.writtenHelpsWanted ?? ""
          )
        },
        bottomActions: {
          CloseCaseAction(
            onCloseCaseTapped: {
              withAnimation { showCloseModal = true }
            },
            onCancelTapped: {
              dismiss()
            }
          )
        }
      )

      if showCloseModal {
        Color.black.opacity(0.4)
          .ignoresSafeArea()
          .onTapGesture {
            withAnimation { showCloseModal = false }
          }

        CloseCase(
          onConfirm: {
            Task {
              await viewModel.closeCase()
              withAnimation { showCloseModal = false }
            }
          },
          onCancel: {
            withAnimation { showCloseModal = false }
          }
        )
      }
    }
    .task {
      await viewModel.loadCase()
    }
    .toast(
      isPresented: $viewModel.showToast,
      message: viewModel.toastMessage
    )
  }
}
// we use a real case ID to see in the preview
#Preview {
  CaseDetailsPage(caseId: "2b8882aa-1247-4cc7-abaa-f52488131726")
}
