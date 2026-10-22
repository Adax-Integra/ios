//
//  HomeCaseProgressTimeline.swift
//  ADAXIntegra
//
//  Created by Lakshmi Jara on 17/10/26.
//

import SwiftUI

// displays the three case steps horizontally on the home screen
struct HomeCaseProgressTimeline: View {
  let steps: [CaseDetailStep]

  var body: some View {
    HStack(alignment: .top, spacing: 0) {
      ForEach(steps.indices, id: \.self) { index in
        let step = steps[index]

        VStack(spacing: 8) {
          HStack(spacing: 0) {
            if index > 0 {
              Rectangle()
                .fill(Color("PrimaryAdax"))
                .frame(height: 2)
            } else {
              Spacer(minLength: 0)
            }

            CaseStepIndicator(
              size: 44,
              status: CaseStepStatus(rawValue: step.status)
            )

            if index < steps.count - 1 {
              Rectangle()
                .fill(Color("PrimaryAdax"))
                .frame(height: 2)
            } else {
              Spacer(minLength: 0)
            }
          }
          .frame(height: 44)

          Text(title(for: step.stepNumber))
            .font(.caption2.bold())
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
      }
    }
  }

  private func title(for number: Int?) -> String {
    switch number {
    case 1: return "Primer contacto"
    case 2: return "Evaluación inicial"
    case 3: return "Acompañamiento"
    default: return "Paso del caso"
    }
  }
}
