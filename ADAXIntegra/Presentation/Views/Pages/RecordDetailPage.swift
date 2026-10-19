//
//  RecordDetailPage.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 07/10/26.
//
//

import SwiftUI

struct RecordDetailPage: View {
  let externalID: String
  // Comes from the record card, so the title works even when the record has no cases
  let externalName: String
  @StateObject private var recordDetailsViewModel = RecordDetailsViewModel()
  @StateObject private var statusViewModel: RecordStatusViewModel
  @State private var showStatusSheet = false
  @State private var showRegisterCase = false
  @State private var showSuccessToast = false

  init(externalID: String, externalName: String, recordId: String, initialStatus: RecordStatus) {
    self.externalID = externalID
    self.externalName = externalName
    _statusViewModel = StateObject(
      wrappedValue: RecordStatusViewModel(
        recordId: recordId,
        initialStatus: initialStatus
      )
    )
  }

  var body: some View {
    ZStack {
      Color("Background").ignoresSafeArea()

      VStack(alignment: .leading, spacing: 0) {

        VStack(alignment: .leading, spacing: 2) {
          HStack(spacing: 0) {
            Text("Casos de ")
              .font(.system(size: 28, weight: .bold))
              .foregroundColor(Color("OnBackground"))
              .lineLimit(1)
              .minimumScaleFactor(0.7)

            Text(externalName.firstName)
              .font(.system(size: 28, weight: .bold))
              .foregroundColor(Color("OnBackground"))
              .lineLimit(1)
              .minimumScaleFactor(0.7)
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.horizontal, .top])

        // R-09: expediente status card with an edit action.
        VStack(alignment: .leading, spacing: 10) {
          Text("ESTATUS DEL EXPEDIENTE")
            .font(.system(size: 13, weight: .bold))
            .foregroundStyle(Color("InsideTextAndIcons"))

          HStack {
            Text(statusViewModel.currentStatus.label)
              .font(.system(size: 15, weight: .semibold))
              .foregroundStyle(statusViewModel.currentStatus.color)
              .padding(.horizontal, 12)
              .padding(.vertical, 6)
              .background(
                Capsule().fill(statusViewModel.currentStatus.color.opacity(0.15))
              )

            Spacer()

            Button {
              showStatusSheet = true
            } label: {
              Text("Editar")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                  RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color("PrimaryAdax"))
                )
            }
          }
        }
        .padding(16)
        .background(
          RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(Color.white)
            .overlay(
              RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color("PrimaryAdax"), lineWidth: 1.5)
            )
        )
        .padding(.horizontal)
        .padding(.top, 8)

        ScrollView {
          LazyVStack(spacing: 16) {
            PrimaryButton(
              title: "Registrar nuevo caso",
              isDisabled: false
            ) {
              showRegisterCase = true
            }
            ForEach(recordDetailsViewModel.recordDetails) { recordDetail in
              NavigationLink {
                CaseDetailsPage(caseId: recordDetail.id)
              } label: {
                RecordCaseDetail(
                  caseId: recordDetail.displayCaseNumber,
                  externalName: recordDetail.userName,
                  urgencyType: recordDetail.urgencyType ?? .sinEvaluar,
                  violenceType: recordDetail.violenceTypes.joined(separator: ", "),
                  internalAssigned: recordDetail.assignedUsers.map(\.name).joined(separator: ", "),
                  lastUpdated: recordDetail.updatedDateString
                )
              }
              .buttonStyle(.plain)
            }
          }
          .padding()
        }
        .refreshable {
          await recordDetailsViewModel.loadRecordDetails(for: externalID)
        }
      }
    }
    .overlay {
      if recordDetailsViewModel.isLoading && recordDetailsViewModel.recordDetails.isEmpty {
        ProgressView()
      } else if let error = recordDetailsViewModel.errorMessage {
        Text(error)
          .foregroundStyle(.secondary)
          .multilineTextAlignment(.center)
          .padding()
          .allowsHitTesting(false)
      }
    }
    .sheet(isPresented: $showStatusSheet) {
      RecordStatusSheet(
        viewModel: statusViewModel,
        externalName: externalName.firstName
      )
    }
    .sheet(isPresented: $showRegisterCase) {
      RegisterCasePage(externalID: externalID) {
        Task {
          await recordDetailsViewModel.loadRecordDetails(for: externalID)
        }
        showSuccessToast = true
      }
    }
    .task {
      await recordDetailsViewModel.loadRecordDetails(for: externalID)
    }
    .toast(
      isPresented: $showSuccessToast,
      message: "Caso registrado correctamente",
      edge: .top
    )
  }
}

#Preview {
  RecordDetailPage(
    externalID: "preview-external-id",
    externalName: "Mariana Corona",
    recordId: "preview-record-id",
    initialStatus: .enRevision
  )
}
