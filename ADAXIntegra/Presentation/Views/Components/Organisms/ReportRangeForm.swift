//
//  ReportRangeForm.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 15/10/26.
//

import SwiftUI

struct ReportRangeForm: View {
  @Binding var startDate: Date
  @Binding var endDate: Date
  let onSelectPreset: (ReportPresets) -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Selecciona un rango predeterminado o selecciona uno más específico")
        .font(.system(size: 15, weight: .medium))
        .foregroundColor(Color("OnBackgroundColor"))

      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 8) {
          ForEach(ReportPresets.allCases, id: \.self) { preset in
            PresetChip(title: preset.title) { onSelectPreset(preset) }
          }
        }
      }

      DateEntry(title: "Fecha de inicio", date: asOptional($startDate))
      DateEntry(title: "Fecha de fin", date: asOptional($endDate))
    }
  }

  private func asOptional(_ date: Binding<Date>) -> Binding<Date?> {
    Binding(
      get: { date.wrappedValue },
      set: { newValue in
        if let newValue { date.wrappedValue = newValue }
      }
    )
  }
}
