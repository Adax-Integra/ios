//
//  CaseViolenceTypesSection.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 17/10/26.
//

import SwiftUI

// "Tipos de violencia" section of the case detail, shows the urgency that comes from the selection

struct CaseViolenceTypesSection: View {
  let violenceTypes: [ViolenceType]
  let urgency: String
  let isSelected: (ViolenceType) -> Bool
  let onToggle: (ViolenceType) -> Void
  var isEnabled: Bool = true
  var isLoading: Bool = false
  var errorMessage: String? = nil

  @State private var isExpanded = true

  // same colors as the case cards
  private var urgencyColor: Color {
    switch urgency {
    case "Alta": return Color("UrgencyHigh")
    case "Media": return Color("UrgencyMedium")
    case "Baja": return Color("UrgencyLow")
    default: return Color("InsideTextAndIcons")
    }
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Button {
        withAnimation { isExpanded.toggle() }
      } label: {
        HStack {
          Text("Tipos de violencia")
            .font(.system(size: 20, weight: .semibold))
            .foregroundColor(Color("OnBackground"))
          Spacer()
          Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
            .foregroundColor(Color("OnBackground"))
        }
        .contentShape(Rectangle())
      }
      .buttonStyle(.plain)
      .accessibilityLabel(isExpanded ? "Ocultar tipos de violencia" : "Mostrar tipos de violencia")

      // urgency updates while the internal marks the options
      HStack(spacing: 8) {
        Circle()
          .fill(urgencyColor)
          .frame(width: 10, height: 10)
        Text("Urgencia: \(urgency)")
          .font(.system(size: 15, weight: .semibold))
          .foregroundColor(Color("OnBackground"))
      }
      .accessibilityElement(children: .combine)
      .accessibilityLabel("Urgencia del caso: \(urgency)")

      if isExpanded {
        if isLoading {
          ProgressView()
            .frame(maxWidth: .infinity)
        } else if let errorMessage {
          Text(errorMessage)
            .font(.system(size: 15))
            .foregroundColor(Color("InsideTextAndIcons"))
        } else if violenceTypes.isEmpty {
          Text("No hay tipos de violencia disponibles")
            .font(.system(size: 15))
            .foregroundColor(Color("InsideTextAndIcons"))
        } else {
          ForEach(violenceTypes) { violence in
            CheckboxRow(
              title: violence.title,
              isChecked: isSelected(violence),
              isEnabled: isEnabled
            ) {
              onToggle(violence)
            }
          }
        }
      }
    }
    .padding(.horizontal, 4)
  }
}

// sample violence types with two of them already assigned
#Preview {
  let violences = [
    ViolenceType(violenceId: "1", description: "Física", severity: 8),
    ViolenceType(violenceId: "2", description: "Psicológica", severity: 6),
    ViolenceType(violenceId: "3", description: "Económica", severity: 5),
    ViolenceType(violenceId: "4", description: "Sexual", severity: 10),
  ]
  let selected: Set<String> = ["1", "2"]

  return ScrollView {
    VStack(spacing: 32) {
      CaseViolenceTypesSection(
        violenceTypes: violences,
        urgency: "Alta",
        isSelected: { selected.contains($0.violenceId) },
        onToggle: { _ in }
      )

      CaseViolenceTypesSection(
        violenceTypes: [],
        urgency: "Sin evaluar",
        isSelected: { _ in false },
        onToggle: { _ in },
        isLoading: true
      )
    }
    .padding()
  }
  .background(Color(UIColor.systemGray6))
}
