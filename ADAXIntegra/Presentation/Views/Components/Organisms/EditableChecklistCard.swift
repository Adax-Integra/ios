//
//  EditableChecklistCard.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 17/10/26.
//

import SwiftUI

// options will be shown in an editable checklist

struct ChecklistOption: Identifiable {
  let id: String
  let title: String
}

// card that opens a list of options

struct EditableChecklistCard: View {
  let title: String
  var subtitle: String? = nil
  var subtitleColor: Color = Color("InsideTextAndIcons")
  // what voiceover reads for the subtitle when the text has symbols like an arrow
  var subtitleAccessibilityText: String? = nil
  let options: [ChecklistOption]
  let isSelected: (String) -> Bool
  let onToggle: (String) -> Void
  let isEditing: Bool
  var canEdit: Bool = true
  var hasChanges: Bool = false
  var isSaving: Bool = false
  var isLoading: Bool = false
  var errorMessage: String? = nil
  var emptyMessage: String = "No hay opciones disponibles"
  // radio when only one option can be selected
  var selectionStyle: CheckboxRowStyle = .checkbox
  let onEdit: () -> Void
  let onCancel: () -> Void
  let onSave: () -> Void

  @State private var isExpanded = false

  var body: some View {
    VStack(alignment: .leading, spacing: 18) {
      Button {
        withAnimation { isExpanded.toggle() }
      } label: {
        HStack {
          VStack(alignment: .leading, spacing: 4) {
            Text(title)
              .font(.system(size: 18, weight: .semibold))
              .foregroundColor(Color("OnBackground"))

            // used by the violence types to show the urgency
            if let subtitle {
              HStack(spacing: 6) {
                Circle()
                  .fill(subtitleColor)
                  .frame(width: 8, height: 8)
                Text(subtitle)
                  .font(.system(size: 14))
                  .foregroundColor(Color("InsideTextAndIcons"))
              }
            }
          }
          Spacer()
          Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
            .foregroundColor(Color("OnBackground"))
        }
        .contentShape(Rectangle())
      }
      .buttonStyle(.plain)
      .accessibilityLabel(isExpanded ? "Ocultar \(title)" : "Mostrar \(title)")
      .accessibilityValue(subtitleAccessibilityText ?? subtitle ?? "")

      if isExpanded {
        options_list
        actions
      }
    }
    .padding(20)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
  }

  @ViewBuilder
  private var options_list: some View {
    if isLoading {
      ProgressView()
        .frame(maxWidth: .infinity)
    } else if let errorMessage {
      Text(errorMessage)
        .font(.system(size: 15))
        .foregroundColor(Color("InsideTextAndIcons"))
    } else if options.isEmpty {
      Text(emptyMessage)
        .font(.system(size: 15))
        .foregroundColor(Color("InsideTextAndIcons"))
    } else {
      ForEach(options) { option in
        CheckboxRow(
          title: option.title,
          isChecked: isSelected(option.id),
          isEnabled: isEditing && !isSaving,
          style: selectionStyle
        ) {
          onToggle(option.id)
        }
      }
    }
  }

  // a closed case will only show the list without buttons
  @ViewBuilder
  private var actions: some View {
    if canEdit && !isLoading && errorMessage == nil && !options.isEmpty {
      HStack(spacing: 12) {
        Spacer()
        if isEditing {
          SecondaryButton(
            customWidth: 120,
            customHeight: 50,
            title: "Cancelar",
            isDisabled: isSaving,
            action: onCancel
          )
          PrimaryButton(
            customWidth: 110,
            customHeight: 23,
            title: isSaving ? "Guardando..." : "Guardar",
            isDisabled: !hasChanges || isSaving,
            action: onSave
          )
        } else {
          SecondaryButton(
            customWidth: 120,
            customHeight: 50,
            title: "Editar",
            isDisabled: false,
            action: onEdit
          )
        }
      }
    }
  }
}

#Preview {
  let options = [
    ChecklistOption(id: "1", title: "Orientación jurídica"),
    ChecklistOption(id: "2", title: "Atención a mujeres"),
    ChecklistOption(id: "3", title: "Acompañamiento jurídico"),
  ]

  return ScrollView {
    VStack(spacing: 20) {
      EditableChecklistCard(
        title: "Tipos de violencia asignados",
        subtitle: "Urgencia: Alta",
        subtitleColor: Color("UrgencyHigh"),
        options: options,
        isSelected: { $0 == "1" },
        onToggle: { _ in },
        isEditing: false,
        onEdit: {},
        onCancel: {},
        onSave: {}
      )

      EditableChecklistCard(
        title: "Tipos de ayuda asignados",
        options: options,
        isSelected: { $0 != "2" },
        onToggle: { _ in },
        isEditing: true,
        hasChanges: true,
        onEdit: {},
        onCancel: {},
        onSave: {}
      )
    }
    .padding()
  }
  .background(Color(UIColor.systemGray6))
}
