//
//  RecordCardInterna.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 02/10/26.
//

import SwiftUI

struct RecordCardInterna: View {
    let item: RecordListItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(item.displayFolio)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color("OnBackground"))
                Spacer()
                if let code = item.status, let status = RecordStatus(rawValue: code) {
                    statusBadge(status)
                }
            }
            
            Text(item.displayName)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color("OnBackground"))
            
            HStack(spacing: 6) {
                Image(systemName: "folder")
                Text(casesText)
            }
            .font(.system(size: 13))
            .foregroundStyle(Color("InsideTextAndIcons"))
            
            HStack(spacing: 6) {
                Image(systemName: "clock")
                Text("Última actualización: \(formattedDate(item.updatedDate))")
            }
            .font(.system(size: 13))
            .foregroundStyle(Color("InsideTextAndIcons"))
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.07), radius: 6, x: 0, y: 3)
        )
    }
    
    private func statusBadge(_ status: RecordStatus) -> some View {
        Text(status.label)
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Capsule().fill(status.color))
    }
    
    private var casesText: String {
        switch item.activeCasesCount {
        case 0: return "Sin casos activos"
        case 1: return "1 caso activo"
        default: return "\(item.activeCasesCount) casos activos"
        }
    }
    
    private func formattedDate(_ date: Date?) -> String {
        guard let date else { return "Sin fecha" }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_MX")
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: date)
    }
}


#Preview {
    ZStack {
        Color("Background").ignoresSafeArea()
        VStack(spacing: 16) {
            RecordCardInterna(item: RecordListItem(
                id: "1", userId: "u1", name: "Daniela Alejandra Herrera Ocampo", recordNumber: "EXP-2026-0001", status: "EN_SEGUIMIENTO", activeCasesCount: 2, updatedAt: "2026-07-12T10:00:00"
            ))
            RecordCardInterna(item: RecordListItem(
                id: "2", userId: "u2", name: "Regina Isabel Morales Fuentes", recordNumber: "EXP-2026-0002", status: "SIN_EMPEZAR", activeCasesCount: 0, updatedAt: nil
            ))
        }
        .padding()
    }
}
