//
//  RecordDetailPage.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 07/10/26.
//
// General page for US v-10, where an internal user can see all the cases of an external user's record

import SwiftUI

struct RecordDetailPage: View {
  let externalID: String
  @StateObject var recordDetailsViewModel = RecordDetailsViewModel()

  var body: some View {
    // Same background and spacing as ListPageTemplate, so it matches the other pages
    ZStack {
      Color("Background").ignoresSafeArea()

      ScrollView {
        LazyVStack(spacing: 16) {
          ForEach(recordDetailsViewModel.recordDetails) { recordDetail in
            RecordCaseDetail(
              caseId: recordDetail.caseNumber ?? recordDetail.id,
              externalName: recordDetail.userName,
              status: recordDetail.status ?? .open,
              violenceType: recordDetail.violenceTypes.joined(separator: ", "),
              internalAssigned: recordDetail.assignedUsers.map(\.name).joined(separator: ", "),
              lastUpdated: recordDetail.updatedDateString
            )
          }
        }
        .padding()
      }
    }
    .overlay {
      if recordDetailsViewModel.isLoading {
        ProgressView()
      } else if let error = recordDetailsViewModel.errorMessage {
        // Also covers the empty state, the view model sets a message when there are no cases
        Text(error)
          .foregroundStyle(.secondary)
          .multilineTextAlignment(.center)
          .padding()
      }
    }
    .task {
      await recordDetailsViewModel.loadRecordDetails(for: externalID)
    }
  }
}

#Preview {
  RecordDetailPage(externalID: "preview-external-id")
}
