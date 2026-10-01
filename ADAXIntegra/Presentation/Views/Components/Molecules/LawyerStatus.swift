//
//  LawyerStatusRow.swift
//
//  Created by Oscar Alexander Vilchis Soto on 30/09/26.
//
// has lawyer badge (question "Cuenta con abogado" and response si / no) for US V-11 getCaseDetails


import SwiftUI

struct LawyerStatusRow: View {
    var hasLawyer: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "info.circle")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.primary)
                .frame(width: 24, alignment: .center)
            
            Text("¿Cuenta con abogado?")
                .font(.system(size: 14))
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(hasLawyer ? "SI" : "NO")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(hasLawyer ? .green : .red)
                .padding(.horizontal, 16)
                .padding(.vertical, 4)
                .background(hasLawyer ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
                .cornerRadius(10)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        LawyerStatusRow(hasLawyer: true)
        LawyerStatusRow(hasLawyer: false)
    }
    .padding()
}
