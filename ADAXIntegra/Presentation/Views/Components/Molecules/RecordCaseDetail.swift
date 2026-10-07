//
//  RecordCaseDetail.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 06/10/26.
//

import SwiftUI

struct RecordCaseDetail: View {
  var recordId: String
  var status: CaseStatus
  var violenceType: String
  var location: String
  var lastUpdated: String

  var body: some View {
    VStack(spacing: 12) {

      HStack {
        Text(recordId)
          .bold()

        Spacer()

        CaseTag(
          width: 75, height: 32,
          rectangleColor: status.tagBackgroundColor,
          textColor: status.tagTextColor,
          textSize: 14,
          text: status.rawValue)
      }

      Divider()

      VStack(spacing: 8) {
        DetailRow(
          iconName: "tag",
          text: violenceType)

        DetailRow(
          iconName: "mappin.and.ellipse",
          iconColor: .orange,
          text: location)

        DetailRow(
          iconName: "clock",
          iconColor: Color(.systemGray),
          text: lastUpdated)
      }
    }
    .padding(16)
    .background(
      RoundedRectangle(cornerRadius: 16)
        .fill(.white)
    )
    .padding(16)
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    RecordCaseDetail(
      recordId: "Caso: 2026-0847-C1",
      status: .active,
      violenceType: "Violencia Familiar",
      location: "Querétaro",
      lastUpdated: "Ultima actualización: 12 Jul 2026"
    )
  }
}
