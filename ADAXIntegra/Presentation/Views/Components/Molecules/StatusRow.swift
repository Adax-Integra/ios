//
//  StatusRow.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 22/09/26.
//

import SwiftUI

struct StatusRow: View {
    let state: CaseState
    let updatedAt: String
    var body: some View {
        HStack {
            HStack(spacing: 6) {
                StatusDot(color: state.indicatorColor)
                Text(state.displayText).font(.system(size: 13, weight: .medium)).foregroundColor(Color("OnBackgroundColor"))
            }
            Spacer()
            DateLabel(prefix: "Actualizado", value: updatedAt)
        }
    }
}
