//
//  CheckboxRow.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 16/10/26.
//
import SwiftUI

// square for several options, circle when only one can be selected
enum CheckboxRowStyle {
  case checkbox
  case radio
}

// option with a checkbox and its text gray when it can not be changed

struct CheckboxRow: View {
  let title: String
  let isChecked: Bool
  var isEnabled: Bool = true
  var style: CheckboxRowStyle = .checkbox
  let onToggle: () -> Void

  private var boxColor: Color {
    guard isChecked else { return Color("InsideTextAndIcons") }
    return isEnabled ? Color("PrimaryAdax") : Color("InsideTextAndIcons")
  }

  private var iconName: String {
    switch style {
    case .checkbox: return isChecked ? "checkmark.square.fill" : "square"
    case .radio: return isChecked ? "largecircle.fill.circle" : "circle"
    }
  }

  var body: some View {
    Button(action: onToggle) {
      HStack(spacing: 12) {
        Image(systemName: iconName)
          .font(.system(size: 22))
          .foregroundColor(boxColor)

        Text(title)
          .font(.system(size: 16))
          .foregroundColor(Color("OnBackground"))
          .multilineTextAlignment(.leading)

        Spacer()
      }
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
    .disabled(!isEnabled)
    .accessibilityLabel(title)
    .accessibilityValue(isChecked ? "Seleccionado" : "No seleccionado")
    // voiceover reads the selected circle as the chosen option
    .accessibilityAddTraits(style == .radio && isChecked ? .isSelected : [])
  }
}

// checked, unchecked and read only options
#Preview {
  VStack(alignment: .leading, spacing: 16) {
    CheckboxRow(title: "Orientación jurídica", isChecked: true) {}
    CheckboxRow(title: "Atención a mujeres", isChecked: false) {}
    CheckboxRow(title: "Acompañamiento jurídico", isChecked: true, isEnabled: false) {}
    CheckboxRow(title: "Etapa 1", isChecked: true, style: .radio) {}
    CheckboxRow(title: "Etapa 2", isChecked: false, style: .radio) {}
  }
  .padding()
  .background(Color(UIColor.systemGray6))
}
