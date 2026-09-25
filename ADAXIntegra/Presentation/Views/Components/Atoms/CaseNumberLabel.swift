//
//  CaseNumberLabel.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 22/09/26.
//

import SwiftUI

struct CaseNumberLabel: View {
    let number: String
    var body: some View {
        Text("ID: \(number)")
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(
            Color("OnBackgroundColor"))
    }
}
