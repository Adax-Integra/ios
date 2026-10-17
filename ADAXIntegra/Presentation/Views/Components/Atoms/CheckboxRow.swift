//
//  CheckboxRow.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 16/10/26.
//
import SwiftUI

// option with a checkbox and its text

struct CheckboxRow: View {
  let title: String
  let isChecked: Bool
  var isEnabled: Bool = true
  let onToggle: () -> Void

  var body: some View {
    Button(action: onToggle) {
      HStack(spacing: 12) {
        Image(systemName: isChecked ? "checkmark.square.fill" : "square")
          .font(.system(size: 20))
          .foregroundColor(isChecked ? Color("PrimaryAdax") : Color("InsideTextAndIcons"))

        Text(title)
          .font(.system(size: 17))
          .foregroundColor(Color("OnBackground"))
          .multilineTextAlignment(.leading)

        Spacer()
      }
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
    .disabled(!isEnabled)
    .opacity(isEnabled ? 1 : 0.5)
    .accessibilityLabel(title)
    .accessibilityValue(isChecked ? "Seleccionado" : "No seleccionado")
  }
}

#Preview {
  VStack(alignment: .leading, spacing: 16) {
    CheckboxRow(title: "Orientación jurídica", isChecked: true) {}
    CheckboxRow(title: "Atención a mujeres", isChecked: false) {}
    CheckboxRow(title: "Acompañamiento jurídico", isChecked: true, isEnabled: false) {}
  }
  .padding()
  .background(Color(UIColor.systemGray6))
}
