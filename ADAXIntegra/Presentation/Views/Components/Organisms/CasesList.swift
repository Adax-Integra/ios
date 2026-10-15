//
//  CasesList.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 22/09/26.
//

import SwiftUI

struct CasesList: View {
  let cases: [Case]
  var onSelectCase: ((Case) -> Void)? = nil

  var body: some View {
    LazyVStack(spacing: 12) {
      ForEach(cases) { caseItem in
        if let onSelectCase = onSelectCase {
          Button {
            onSelectCase(caseItem)
          } label: {
            CaseCard(caseItem: caseItem)
          }
          .buttonStyle(.plain)
          .accessibilityHint("Consultar el progreso del caso")
        } else {
          CaseCard(caseItem: caseItem)
        }
      }
    }
  }
}
