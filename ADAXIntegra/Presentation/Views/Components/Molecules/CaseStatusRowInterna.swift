//
//  CaseStatusRow.swift
//  ADAXIntegra
//
//  Created by Nicolás Bravo Miguel on 22/09/26.
//

import SwiftUI

struct CaseStatusRow: View {
  let state: String
  let updatedAt: Date?

  // Unrecognized state strings fall back to "Sin empezar" (red) rather than
  // "Finalizado" (green), so an unexpected value doesn't read as resolved.
  private var dotStatus: StatusDotInterna.Status {
    switch state {
    case "En proceso":
      return .enProceso
    case "Finalizado":
      return .finalizado
    default:
      return .sinEmpezar
    }
  }

  private var updatedAtLabel: String {
    guard let updatedAt else { return "Sin actualizar" }

    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    return formatter.string(from: updatedAt)
  }

  var body: some View {
    HStack(spacing: 6) {
      StatusDotInterna(status: dotStatus)

      Text(state)
        .font(.system(size: 14, weight: .medium))
        .foregroundColor(Color("OnBackground"))

      Spacer()

      Text(updatedAtLabel)
        .font(.system(size: 12, weight: .regular))
        .foregroundColor(Color("InsideTextAndIcons"))
    }
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    VStack(spacing: 12) {
      CaseStatusRow(state: "Sin empezar", updatedAt: Date())
      CaseStatusRow(state: "En proceso", updatedAt: Date())
      CaseStatusRow(state: "Finalizado", updatedAt: Date())
      CaseStatusRow(state: "Finalizado", updatedAt: nil)
    }
    .padding()
  }
}
