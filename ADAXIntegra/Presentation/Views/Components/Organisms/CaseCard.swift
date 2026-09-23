//
//  CaseCard.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 23/09/26.
//

import SwiftUI

struct CaseCard: View {
  let name: String
  let urgency: String
  let state: String
  let updateAt: Date?
  let categories: [String]

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      CaseHeader(name: name, urgency: urgency)

      CaseStatusRow(state: state, updatedAt: updateAt)

      if !categories.isEmpty {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 8) {
            ForEach(categories, id: \.self) { category in CaseCategoryTag(category: category)
            }
          }
        }
      }
    }

    .padding(16)
    .background(
      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .fill(Color.white)
        .shadow(color: Color.black.opacity(0.07), radius: 6, x: 0, y: 3)
    )
  }

}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    VStack(spacing: 16) {
      CaseCard(
        name: "Maria López",
        urgency: "Alta",
        state: "En processo",
        updateAt: Date(),
        categories: ["Violencia Familiar", "Violencia Económica"]
      )

      CaseCard(
        name: "Ana Torres",
        urgency: "Baja",
        state: "Sin empezar",
        updateAt: nil,
        categories: ["Violencia psioclógica"]
      )
    }
    .padding()

  }
}
