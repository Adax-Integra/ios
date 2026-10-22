//
//  VerificationStatus.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 16/10/26.
//

import SwiftUI

enum VerificationStatus: String {
  case noVerificado = "NO_VERIFICADO"
  case enRevision = "EN_REVISION"
  case verificado = "VERIFICADO"

  var label: String {
    switch self {
    case .noVerificado: return "No verificado"
    case .enRevision: return "En revisión"
    case .verificado: return "Verificado"
    }
  }

  var color: Color {
    switch self {
    case .noVerificado: return Color("Error")
    case .enRevision: return Color("StatusInProgress")
    case .verificado: return Color("StatusCompleted")
    }
  }

  var icon: String {
    switch self {
    case .noVerificado: return "exclamationmark.shield"
    case .enRevision: return "clock.badge"
    case .verificado: return "checkmark.seal.fill"
    }
  }
}
