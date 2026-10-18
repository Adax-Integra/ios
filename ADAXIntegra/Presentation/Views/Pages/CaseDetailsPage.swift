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

  // help types that the internal assigns to the case
  @StateObject private var helpsViewModel: CaseHelpsViewModel

  @State private var showCloseModal = false
  // R-10: the case detail does not send who is assigned, so the saved ones are kept here
  @State private var assignedCollaboratorIds: Set<String> = []
  @Environment(\.dismiss) private var dismiss

  init(caseId: String) {
    self.caseId = caseId
    _viewModel = StateObject(wrappedValue: CaseDetailViewModel(caseId: caseId))
    _helpsViewModel = StateObject(wrappedValue: CaseHelpsViewModel(caseId: caseId))
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

  // a closed case can not be edited
  private var isCaseOpen: Bool {
    viewModel.caseDetail?.state == "Open"
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
            recordId: viewModel.caseDetail?.record.recordNumber
              ?? viewModel.caseDetail?.recordId
              ?? "—",
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

          CaseHelpTypesSection(
            helpTypes: helpsViewModel.helpTypes,
            isSelected: { helpsViewModel.isSelected($0) },
            onToggle: { helpsViewModel.toggle($0) },
            isEnabled: isCaseOpen,
            isLoading: helpsViewModel.isLoading,
            errorMessage: helpsViewModel.errorMessage
          )

          // R-10: the assignment lives on its own page so this one stays lighter
          NavigationLink {
            AssignCollaboratorPage(
              caseId: caseId,
              caseNumber: viewModel.caseDetail?.caseNumber ?? "—",
              assignedIds: assignedCollaboratorIds,
              onAssigned: { ids in
                assignedCollaboratorIds.formUnion(ids)
              }
            )
          } label: {
            HStack(spacing: 8) {
              Icon(color: Color("PrimaryAdax"), systemName: "person.badge.plus")

              Text("Asignar colaboradora")
                .font(.headline)
                .foregroundColor(Color("PrimaryAdax"))
            }
            .frame(maxWidth: .infinity, maxHeight: 23)
            .padding()
            .background(
              RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color("PrimaryAdax"), lineWidth: 2)
            )
          }
          .buttonStyle(.plain)
          .disabled(!isCaseOpen)
          .opacity(isCaseOpen ? 1.0 : 0.6)
        },
        bottomActions: {
          VStack(spacing: 0) {
            PrimaryButton(
              customWidth: 329,
              customHeight: 23,
              title: helpsViewModel.isSaving ? "Guardando..." : "Guardar",
              isDisabled: !isCaseOpen || !helpsViewModel.hasChanges || helpsViewModel.isSaving,
              action: {
                Task { await helpsViewModel.save() }
              }
            )
            .padding(.horizontal, 16)
            .padding(.top, 16)

            CloseCaseAction(
              onCloseCaseTapped: {
                withAnimation { showCloseModal = true }
              },
              onCancelTapped: {
                dismiss()
              }
            )
          }
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
      await helpsViewModel.load(
        assignedIds: viewModel.caseDetail?.helps.compactMap(\.helpId) ?? []
      )
    }
    .toast(
      isPresented: $viewModel.showToast,
      message: viewModel.toastMessage
    )
    .toast(
      isPresented: $helpsViewModel.showToast,
      message: helpsViewModel.toastMessage
    )
  }
}
// we use a real case ID to see in the preview
#Preview {
  CaseDetailsPage(caseId: "8c097b2f-5418-45ba-ab5f-9fc866fbe778")
}
