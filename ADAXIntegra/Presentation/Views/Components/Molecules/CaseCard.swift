//
//  CaseCard.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 22/09/26.
//

import SwiftUI

struct CaseCard: View {
  let caseItem: Case
  private var state: CaseState { CaseState(dbValue: caseItem.state) }
  var body: some View {
    HStack(spacing: 0) {
      Rectangle().fill(state.indicatorColor).frame(width: 4)
      VStack(alignment: .leading, spacing: 8) {
        CaseNumberLabel(
          number: String(caseItem.id.prefix(8))
        )
        CaseTypeLabel(
          text: caseItem.violenceTypes.isEmpty
            ? "Sin tipo asignado"
            : caseItem.violenceTypes.joined(separator: ", ")
        )
        StatusRow(
          state: .pending,
          updatedAt: caseItem.updatedAtDate?.relativeDescription ?? "-")
      }
      .padding(16)
    }
    .background(Color("CardColor"))
    .clipShape(RoundedRectangle(cornerRadius: 12))
  }
}

extension Date {
  var relativeDescription: String {
    RelativeDateTimeFormatter().localizedString(for: self, relativeTo: Date())
  }
}
