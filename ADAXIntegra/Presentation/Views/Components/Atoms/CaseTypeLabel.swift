//
//  CaseTypeLabel.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 22/09/26.
//

import SwiftUI

struct CaseTypeLabel: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.system(size: 15, weight: .regular))
            .foregroundColor(Color("OnBackgroundColor"))
    }
}
