//
//  CaseStepsSelector.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 18/10/26.
//

import SwiftUI

struct CaseStepSelector: View {
  let selectedStep: CaseStepOption?
  let isEnabled: Bool
  let onSelect: (CaseStepOption) -> Void

  var body: some View {
    SurfaceCard {
      VStack(alignment: .leading, spacing: 4) {
        Text("Etapa del caso")
          .font(.headline)
          .foregroundColor(Color("OnBackground"))

        ForEach(CaseStepOption.allCases) { step in
          StepOptionRow(title: step.title, isSelected: step == selectedStep) {
            onSelect(step)
          }
        }
      }
      .padding(16)
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .disabled(!isEnabled)
    .opacity(isEnabled ? 1.0 : 0.6)
  }
}
