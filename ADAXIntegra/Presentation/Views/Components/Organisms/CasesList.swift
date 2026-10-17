//
//  CasesList.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 22/09/26.
//

import SwiftUI

struct CasesList: View {
  let cases: [Case]
  var onLoadMore: () -> Void = {}

  var body: some View {
    LazyVStack(spacing: 12) {
      ForEach(cases) { item in
        CaseCard(caseItem: item)
          .onAppear {
            if item.id == cases.last?.id { onLoadMore() }
          }
      }
    }
  }
}
