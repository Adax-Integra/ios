//
//  CaseProgressTimeline.swift
//  ADAXIntegra
//
//  Created by Lakshmi Jara on 15/10/26.
//

import SwiftUI

struct CaseProgressTimeline: View {
  let steps: [CaseDetailStep]

  var body: some View {
    VStack(spacing: 0) {
      ForEach(steps.indices, id: \.self) { index in
        let step = steps[index]

        HStack(alignment: .top, spacing: 12) {
          Color.clear
            .frame(width: 36)
            .overlay(alignment: .top) {
              if index < steps.count - 1 {
                Rectangle()
                  .fill(Color("PrimaryAdax"))
                  .frame(width: 2)
                  .padding(.top, 18)
              }
            }
            .overlay(alignment: .top) {
              CaseStepIndicator(
                status: CaseStepStatus(rawValue: step.status)
              )
              .padding(.top, 18)
            }

          CaseStepCard(
            title: title(for: step.stepNumber),
            description: description(for: step.stepNumber),
            status: CaseStepStatus(rawValue: step.status)
          )
          .padding(.bottom, index < steps.count - 1 ? 24 : 0)
        }
      }
    }
  }

  private func title(for number: Int?) -> String {
    switch number {
    case 1:
      return "1. Primer contacto"
    case 2:
      return "2. Evaluación inicial"
    case 3:
      return "3. Acompañamiento"
    default:
      return "Paso del caso"
    }
  }

  // describe each stage, not its current progress
  private func description(for number: Int?) -> String {
    switch number {
    case 1:
      return
        "Se estableció el primer contacto y se brindó información sobre los servicios y el proceso de acompañamiento."
    case 2:
      return "Se realizó la evaluación inicial para conocer su situación y necesidades específicas."
    case 3:
      return "Seguimiento y acompañamiento durante el proceso del caso."
    default:
      return "Información del seguimiento del caso."
    }
  }
}

#Preview {
  ZStack {
    Color("BackgroundColor").ignoresSafeArea()

    ScrollView {
      CaseProgressTimeline(steps: [
        CaseDetailStep(
          caseStepId: "1",
          stepNumber: 1,
          status: "completado"
        ),
        CaseDetailStep(
          caseStepId: "2",
          stepNumber: 2,
          status: "en progreso"
        ),
        CaseDetailStep(
          caseStepId: "3",
          stepNumber: 3,
          status: "pendiente"
        ),
      ])
      .padding(24)
    }
  }
}
