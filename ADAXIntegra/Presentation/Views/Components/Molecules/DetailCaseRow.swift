//
//  DetailCaseRow.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 30/09/26.
// Detail card of a specific case for US V-11
//


import SwiftUI

struct DetailRow: View {
    var iconName: String
    var iconColor: Color = Color("PrimaryAdax")
    var text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(iconColor)
                .frame(width: 24, alignment: .center)
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        DetailRow(iconName: "tag", text: " ")
        DetailRow(iconName: "mappin.and.ellipse", iconColor: .orange, text: "")
    }
    .padding()
}

