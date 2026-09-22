//
//  StatusDot.swift
//  ADAXIntegra
//
//  Created by Nicolás Bravo Miguel on 21/09/26.
//

import SwiftUI

struct StatusDot: View {
  enum Status {
    case sinEmpezar
    case enProceso
    case finalizado

    var color: Color {
      switch self {
      case .sinEmpezar:
        return Color("StatusNotStarted")
      case .enProceso:
        return Color("StatusInProgress")
      case .finalizado:
        return Color("StatusCompleted")
      }
    }
  }

  var size: CGFloat = 10

  let status: Status

  var body: some View {
    Circle()
      .fill(status.color)
      .frame(width: size, height: size)
  }
}

#Preview {
  HStack(spacing: 16) {
    StatusDot(status: .sinEmpezar)
    StatusDot(status: .enProceso)
    StatusDot(status: .finalizado)
  }
  .padding()
}
