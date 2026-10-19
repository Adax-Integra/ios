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

  // violence types that the internal assigns to the case, they decide the urgency
  @StateObject private var violenceViewModel: CaseViolenceViewModel

  @State private var showCloseModal = false
  // R-12: collaborators of the case, they come from the case detail and change after saving
  @State private var assignedCollaboratorIds: Set<String> = []
  @Environment(\.dismiss) private var dismiss

  init(caseId: String) {
    self.caseId = caseId
    _viewModel = StateObject(wrappedValue: CaseDetailViewModel(caseId: caseId))
    _helpsViewModel = StateObject(wrappedValue: CaseHelpsViewModel(caseId: caseId))
    _violenceViewModel = StateObject(wrappedValue: CaseViolenceViewModel(caseId: caseId))
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

  // R-12: once there are collaborators the same page is used to change them
  private var collaboratorsButtonTitle: String {
    let count = assignedCollaboratorIds.count
    return count == 0 ? "Asignar colaboradora" : "Colaboradoras asignadas (\(count))"
  }

  // a closed case can not be edited
  private var isCaseOpen: Bool {
    viewModel.caseDetail?.state == "Open"
  }

  // same colors as the case cards
  private var urgencyColor: Color {
    switch violenceViewModel.urgency {
    case "Alta": return Color("UrgencyHigh")
    case "Media": return Color("UrgencyMedium")
    case "Baja": return Color("UrgencyLow")
    default: return Color("InsideTextAndIcons")
    }
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

          EditableChecklistCard(
            title: "Tipos de violencia asignados",
            subtitle: "Urgencia: \(violenceViewModel.urgency)",
            subtitleColor: urgencyColor,
            options: violenceViewModel.violenceTypes.map {
              ChecklistOption(id: $0.violenceId, title: $0.title)
            },
            isSelected: { violenceViewModel.isSelected(id: $0) },
            onToggle: { violenceViewModel.toggle(id: $0) },
            isEditing: violenceViewModel.isEditing,
            canEdit: isCaseOpen,
            hasChanges: violenceViewModel.hasChanges,
            isSaving: violenceViewModel.isSaving,
            isLoading: violenceViewModel.isLoading,
            errorMessage: violenceViewModel.errorMessage,
            emptyMessage: "No hay tipos de violencia disponibles",
            onEdit: { violenceViewModel.startEditing() },
            onCancel: { violenceViewModel.cancelEditing() },
            onSave: { Task { await violenceViewModel.save() } }
          )

          CaseHelpWanted(
            helpwanted: viewModel.caseDetail?.writtenHelpsWanted ?? ""
          )

          EditableChecklistCard(
            title: "Tipos de ayuda asignados",
            options: helpsViewModel.helpTypes.map {
              ChecklistOption(id: $0.helpId, title: $0.title)
            },
            isSelected: { helpsViewModel.isSelected(id: $0) },
            onToggle: { helpsViewModel.toggle(id: $0) },
            isEditing: helpsViewModel.isEditing,
            canEdit: isCaseOpen,
            hasChanges: helpsViewModel.hasChanges,
            isSaving: helpsViewModel.isSaving,
            isLoading: helpsViewModel.isLoading,
            errorMessage: helpsViewModel.errorMessage,
            emptyMessage: "No hay tipos de ayuda disponibles",
            onEdit: { helpsViewModel.startEditing() },
            onCancel: { helpsViewModel.cancelEditing() },
            onSave: { Task { await helpsViewModel.save() } }
          )

          // R-10: the assignment lives on its own page so this one stays lighter
          NavigationLink {
            AssignCollaboratorPage(
              caseId: caseId,
              caseNumber: viewModel.caseDetail?.caseNumber ?? "—",
              assignedIds: assignedCollaboratorIds,
              onSaved: { ids in
                assignedCollaboratorIds = ids
              }
            )
          } label: {
            HStack(spacing: 8) {
              Icon(color: Color("PrimaryAdax"), systemName: "person.badge.plus")

              Text(collaboratorsButtonTitle)
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
      assignedCollaboratorIds = Set(viewModel.caseDetail?.assignedUserIds ?? [])
      await violenceViewModel.load(
        assignedIds: viewModel.caseDetail?.violenceTypes.compactMap(\.violenceId) ?? []
      )
      await helpsViewModel.load(
        assignedIds: viewModel.caseDetail?.helps.compactMap(\.helpId) ?? []
      )
    }
    .toast(
      isPresented: $viewModel.showToast,
      message: viewModel.toastMessage
    )
    .toast(
      isPresented: $violenceViewModel.showToast,
      message: violenceViewModel.toastMessage
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
