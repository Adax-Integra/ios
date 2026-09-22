//
//  StatusBadge.swift
//  Created by Oscar Alexander Vilchis Soto on 22/09/26.
//
// Status badge for V-11 that describes if a case is "Open" or "Closed"
//


import SwiftUI

struct StatusBadge: View {
    var text: String
    var fontSize: CGFloat = 12
    
    var body: some View {
        Text(text.capitalized)
            .font(.system(size: fontSize, weight: .bold))
            .foregroundColor(Color("PrimaryAdax"))
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(Color("PrimaryAdax").opacity(0.15))
            .cornerRadius(12)
            
    }
    
}

#Preview{
    HStack(spacing:20){
        StatusBadge(text: "Abierto")
        StatusBadge(text: "Cerrado", fontSize: 16)
            .padding()
    }
}

