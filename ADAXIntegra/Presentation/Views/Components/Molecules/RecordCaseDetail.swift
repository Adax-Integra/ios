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
  var urgencyType: UrgencyType
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
      }

      Divider()

      VStack(alignment: .leading, spacing: 7) {
        HStack(spacing: 2) {
          Text("Violencia: ")
            .fontWeight(.bold)
            .fixedSize()
          Text(violenceType)
            .lineLimit(1)
            .truncationMode(.tail)
        }

        HStack(spacing: 2) {
          Text("Asignada al caso: ")
            .fontWeight(.bold)
            .fixedSize()
          Text(internalAssigned)
            .lineLimit(1)
            .truncationMode(.tail)
        }
      }
      .font(.system(size: 14))
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
    .padding(.leading, 4)
    .background(Color(.systemBackground))
    .overlay(alignment: .leading) {
      Rectangle()
        .fill(urgencyType.tagBorderColor)
        .frame(width: 6)
    }
    .clipShape(RoundedRectangle(cornerRadius: 16))
    .shadow(color: .black.opacity(0.2), radius: 1, x: 1, y: 1)
  }
}

enum UrgencyType: String {
  case alta
  case media
  case baja
  case sinEvaluar = "sin evaluar"

  var tagBorderColor: Color {
    switch self {
    case .alta:
      return Color("UrgencyHigh")
    case .media:
      return Color("UrgencyMedium")
    case .baja:
      return Color("UrgencyLow")
    case .sinEvaluar:
      return Color(.systemGray)
    }
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    RecordCaseDetail(
      caseId: "C-26-9999",
      externalName: "Adriana Velásquez",
      urgencyType: .baja,
      violenceType: "Familiar",
      internalAssigned: "Alejandra Benítez ",
      lastUpdated: "12 Jul 2026"
    )
    .padding()
  }
}
