//
//  CasesList.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 22/09/26.
//

import SwiftUI

struct CasesList: View {
    let cases: [Case]
    var body: some View {
        LazyVStack(spacing: 12) {
            ForEach(cases) { CaseCard(caseItem: $0) }
        }
    }
}
