//
//  CaseCard.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 22/09/26.
//

import SwiftUI

struct CaseCard: View {
    let caseItem: Case
    var body: some View {
        HStack(spacing: 0) {
            Rectangle().fill(caseItem.state.indicatorColor).frame(width: 4)
            VStack(alignment: .leading, spacing: 8) {
                CaseNumberLabel(number: caseItem.caseNumber ?? caseItem.id.uuidString.prefix(8).description)
                DateLabel(prefix: "Fecha de creación", value: caseItem.createdAt.formatted(date: .numeric, time: .shortened))
                CaseTypeLabel(text: caseItem.description)
                StatusRow(state: caseItem.state, updatedAt: caseItem.updatedAt.relativeDescription)
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
