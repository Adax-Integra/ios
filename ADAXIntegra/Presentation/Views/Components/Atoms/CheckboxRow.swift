//
//  CheckboxRow.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 16/10/26.
//
import SwiftUI

// option with a checkbox and its text gray when it can not be changed

struct CheckboxRow: View {
  let title: String
  let isChecked: Bool
  var isEnabled: Bool = true
  let onToggle: () -> Void

  private var boxColor: Color {
    guard isChecked else { return Color("InsideTextAndIcons") }
    return isEnabled ? Color("PrimaryAdax") : Color("InsideTextAndIcons")
  }

  var body: some View {
    Button(action: onToggle) {
      HStack(spacing: 12) {
        Image(systemName: isChecked ? "checkmark.square.fill" : "square")
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
  }
}

// checked, unchecked and read only options
#Preview {
  VStack(alignment: .leading, spacing: 16) {
    CheckboxRow(title: "Orientación jurídica", isChecked: true) {}
    CheckboxRow(title: "Atención a mujeres", isChecked: false) {}
    CheckboxRow(title: "Acompañamiento jurídico", isChecked: true, isEnabled: false) {}
  }
  .padding()
  .background(Color(UIColor.systemGray6))
}
