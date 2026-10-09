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
  @StateObject var recordDetailsViewModel = RecordDetailsViewModel()

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

            Text(recordDetailsViewModel.userFirstName)
              .font(.system(size: 28, weight: .bold))
              .foregroundColor(Color("OnBackground"))
              .lineLimit(1)
              .minimumScaleFactor(0.7)
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.horizontal, .top])

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
    .task {
      await recordDetailsViewModel.loadRecordDetails(for: externalID)
    }
  }
}

#Preview {
  RecordDetailPage(externalID: "preview-external-id")
}
