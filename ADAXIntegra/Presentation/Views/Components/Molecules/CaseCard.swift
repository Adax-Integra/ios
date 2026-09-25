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
            Rectangle().fill(Color.orange).frame(width: 4)
            VStack(alignment: .leading, spacing: 8) {
                CaseNumberLabel(
                    number: String(caseItem.id.prefix(8))
                )
                DateLabel(
                    prefix: "Fecha de creación",
                    value: caseItem.createdAt)
                CaseTypeLabel(
                    text: caseItem.violenceTypes.isEmpty
                        ? "Sin tipo asignado"
                        : caseItem.violenceTypes.joined(separator: ", ")
                      )
                StatusRow(
                    state: .pending,
                    updatedAt: caseItem.updatedAt) // hardcoded due to lack of status on table
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
