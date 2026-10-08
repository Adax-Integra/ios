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
    List(recordDetailsViewModel.recordDetails) { recordDetail in
      RecordCaseDetail(
        caseId: recordDetail.caseNumber ?? recordDetail.id,
        externalName: recordDetail.userName,
        status: recordDetail.status ?? .open,
        violenceType: recordDetail.violenceTypes.joined(separator: ", "),
        internalAssigned: recordDetail.assignedUsers.joined(separator: ", "),
        lastUpdated: recordDetail.updatedDateString
      )
    }
    .task {
      await recordDetailsViewModel.loadRecordDetails(for: externalID)
    }
  }
}

#Preview {
  RecordDetailPage(externalID: "preview-external-id")
}
