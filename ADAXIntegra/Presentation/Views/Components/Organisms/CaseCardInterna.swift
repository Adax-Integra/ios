//
//  CaseCard.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 23/09/26.
//

import SwiftUI

struct CaseCardInterna: View {
  let caseNumber: String
  let name: String
  let urgency: String
  let violenceTypes: [String]
  let assignedTo: [String]

  // same colores as the resto of the case lists
  private var urgencyColor: Color {
    switch urgency {
    case "Alta": return Color("UrgencyHigh")
    case "Media": return Color("UrgencyMedium")
    case "Baja": return Color("UrgencyLow")
    default: return Color("InsideTextAndIcons")
    }
  }

  private func joined(_ values: [String]) -> String {
    values.isEmpty ? "-" : values.joined(separator: ", ")
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("N.º DE CASO")
        .font(.system(size: 11, weight: .bold))
        .foregroundColor(Color("InsideTextAndIcons"))

      Text(caseNumber)
        .font(.system(size: 22, weight: .bold))
        .foregroundColor(Color("OnBackground"))

      Text(name)
        .font(.system(size: 16))
        .foregroundColor(Color("OnBackground"))
        .lineLimit(1)

      Divider()
        .padding(.vertical, 4)

      infoRow(title: "Violencia:", value: joined(violenceTypes))
      infoRow(title: "Asignada al caso:", value: joined(assignedTo))
    }
    .padding(.leading, 22)
    .padding(.trailing, 16)
    .padding(.vertical, 14)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color.white)
    .overlay(alignment: .leading) {
      urgencyColor
        .frame(width: 6)
    }
    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    .shadow(color: Color.black.opacity(0.07), radius: 6, x: 0, y: 3)
    .accessibilityElement(children: .combine)
    .accessibilityLabel(
      "Caso \(caseNumber), \(name), urgencia \(urgency), violencia \(joined(violenceTypes)), asignada a \(joined(assignedTo))"
    )
  }

  // Bold title followed by its value in gray
  private func infoRow(title: String, value: String) -> some View {
    (Text(title + " ")
      .font(.system(size: 15, weight: .semibold))
      .foregroundColor(Color("OnBackground"))
      + Text(value)
      .font(.system(size: 15))
      .foregroundColor(Color("InsideTextAndIcons")))
      .lineLimit(2)
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    VStack(spacing: 16) {
      CaseCardInterna(
        caseNumber: "C-26-9999",
        name: "Adriana Velásquez Mondragón",
        urgency: "Alta",
        violenceTypes: ["Sexual", "Psicológica"],
        assignedTo: ["Alejandra Benítez"]
      )

      CaseCardInterna(
        caseNumber: "C-26-0042",
        name: "Ana Torres",
        urgency: "Baja",
        violenceTypes: ["Económica"],
        assignedTo: []
      )
    }
    .padding()
  }
}
