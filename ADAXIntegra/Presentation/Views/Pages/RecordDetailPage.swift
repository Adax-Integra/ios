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
      HStack {
        RecordCaseDetail(
          caseId: "Caso: \(recordDetail.id)",
          externalName: "Adriana",
          status: recordDetail.state == "Closed" ? .closed : .open,
          violenceType: recordDetail.violenceTypes.joined(separator: ", "),
          internalAssigned: "Veronica",
          lastUpdated: "Última actualización: \(recordDetail.updatedDateString)"
        )
      }
    }.onAppear {
      Task {
        await recordDetailsViewModel.loadRecordDetails(for: externalID)
      }
    }
  }
}

#Preview {
  RecordDetailPage(externalID: "preview-external-id")
}
