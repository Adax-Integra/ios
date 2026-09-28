//
//  CountBadge.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 22/09/26.
//

import SwiftUI

struct CountBadge: View {
    let count: Int
    var body: some View {
        Text("\(count) Casos")
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(Color("PrimaryColor"))
            .padding(.horizontal, 10).padding(.vertical, 4)
            .background(Color("TertiaryColor").opacity(0.5))
            .clipShape(Capsule())
    }
}
