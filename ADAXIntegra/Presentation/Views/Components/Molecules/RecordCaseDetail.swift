//
//  RecordCaseDetail.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 06/10/26.
//

import SwiftUI

struct RecordCaseDetail: View {
  var caseId: String
  var externalName: String
  var status: CaseStatus
  var violenceType: String
  var internalAssigned: String
  var lastUpdated: String

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {

      HStack {
        VStack(alignment: .leading, spacing: 4) {
          Text("N°. DE CASO")
            .font(.system(size: 13))
            .fontWeight(.heavy)
            .foregroundStyle(.gray)

          HStack {
            Text(caseId)
              .fontWeight(.heavy)

            Spacer()
          }

          Text(externalName)
        }

        CaseTag(
          width: 75, height: 27,
          rectangleColor: status.tagBackgroundColor,
          textColor: status.tagTextColor,
          textSize: 14,
          text: status.rawValue
        )
        .padding(.bottom, 40)

      }

      Divider()

      VStack(alignment: .leading, spacing: 7) {
        HStack(spacing: 2) {
          Text("Violencia: ")
            .fontWeight(.bold)
          Text(violenceType)
        }

        HStack(spacing: 2) {
          Text("Asignada al caso: ")
            .fontWeight(.bold)
          Text(internalAssigned)
        }

        HStack(spacing: 2) {
          Text("Última actualización: ")
          Text(lastUpdated)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .font(.system(size: 12))
        .padding(.top, 6)
      }
      .font(.system(size: 14))
    }
    .padding(20)
    .padding(.leading, 3)
    .background(.white)
    .overlay(alignment: .leading) {
      Rectangle()
        .fill(status.tagTextColor)
        .frame(width: 7)
    }
    .clipShape(RoundedRectangle(cornerRadius: 10))
    .padding(16)
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    RecordCaseDetail(
      caseId: "C-26-9999",
      externalName: "Adriana Velásquez",
      status: .open,
      violenceType: "Familiar",
      internalAssigned: "Alejandra Benítez",
      lastUpdated: "12 Jul 2026"
    )
  }
}
