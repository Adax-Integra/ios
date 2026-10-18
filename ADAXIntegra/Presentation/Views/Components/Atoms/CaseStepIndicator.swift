//
//  CaseStepIndicator.swift
//  ADAXIntegra
//
//  Created by Lakshmi Jara on 15/10/26.
//

import SwiftUI

struct CaseStepIndicator: View {
  var size: CGFloat = 36
  let status: CaseStepStatus

  private var color: Color {
    Color("PrimaryAdax")
  }

  var body: some View {
    ZStack {
      Circle()
        .fill(
          status == .completed
            ? color
            : Color("CardColor")
        )

      Circle()
        .strokeBorder(color, lineWidth: 2)

      // each status has a distinct shape in addition to its color
      switch status {
      case .completed:
        Image(systemName: "checkmark")
          .font(.system(size: size * 0.4, weight: .bold))
          .foregroundStyle(.white)

      case .inProgress:
        Circle()
          .fill(color)
          .frame(width: size * 0.4, height: size * 0.4)

      case .pending:
        EmptyView()

      case .unknown:
        EmptyView()
      }
    }
    .frame(width: size, height: size)
    .accessibilityElement(children: .ignore)
    .accessibilityLabel(Text(status.displayText))
  }
}

#Preview {
  HStack(spacing: 16) {
    CaseStepIndicator(status: .completed)
    CaseStepIndicator(status: .inProgress)
    CaseStepIndicator(status: .pending)
  }
  .padding()
}
