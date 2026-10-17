//
//  CaseHelpTypesSection.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 16/10/26.
//

import SwiftUI

// "Tipos de ayuda" section of the case detail, can be collapsed

struct CaseHelpTypesSection: View {
  let helpTypes: [HelpType]
  let isSelected: (HelpType) -> Bool
  let onToggle: (HelpType) -> Void
  var isEnabled: Bool = true
  var isLoading: Bool = false
  var errorMessage: String? = nil

  @State private var isExpanded = true

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Button {
        withAnimation { isExpanded.toggle() }
      } label: {
        HStack {
          Text("Tipos de ayuda")
            .font(.system(size: 20, weight: .semibold))
            .foregroundColor(Color("OnBackground"))
          Spacer()
          Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
            .foregroundColor(Color("OnBackground"))
        }
        .contentShape(Rectangle())
      }
      .buttonStyle(.plain)
      .accessibilityLabel(isExpanded ? "Ocultar tipos de ayuda" : "Mostrar tipos de ayuda")

      if isExpanded {
        if isLoading {
          ProgressView()
            .frame(maxWidth: .infinity)
        } else if let errorMessage {
          Text(errorMessage)
            .font(.system(size: 15))
            .foregroundColor(Color("InsideTextAndIcons"))
        } else if helpTypes.isEmpty {
          Text("No hay tipos de ayuda disponibles")
            .font(.system(size: 15))
            .foregroundColor(Color("InsideTextAndIcons"))
        } else {
          ForEach(helpTypes) { help in
            CheckboxRow(
              title: help.title,
              isChecked: isSelected(help),
              isEnabled: isEnabled
            ) {
              onToggle(help)
            }
          }
        }
      }
    }
    .padding(.horizontal, 4)
  }
}

// sample help types with two of them already assigned
#Preview {
  let helps = [
    HelpType(helpId: "1", description: "Orientación jurídica"),
    HelpType(helpId: "2", description: "Atención a mujeres"),
    HelpType(helpId: "3", description: "Acompañamiento jurídico"),
    HelpType(helpId: "4", description: "Canalización para atención psicológica"),
    HelpType(helpId: "5", description: "Banco de alimentos"),
  ]
  let selected: Set<String> = ["1", "3"]

  return ScrollView {
    VStack(spacing: 32) {
      CaseHelpTypesSection(
        helpTypes: helps,
        isSelected: { selected.contains($0.helpId) },
        onToggle: { _ in }
      )

      CaseHelpTypesSection(
        helpTypes: [],
        isSelected: { _ in false },
        onToggle: { _ in },
        isLoading: true
      )

      CaseHelpTypesSection(
        helpTypes: [],
        isSelected: { _ in false },
        onToggle: { _ in },
        errorMessage: "No se pudieron cargar los tipos de ayuda."
      )
    }
    .padding()
  }
  .background(Color(UIColor.systemGray6))
}
