//
//  CaseStepsOptions.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 18/10/26.
//
// As far as I can tell existing CaseStepsStatus doesn't
// actually relate to the case_steps table, its about the state
// column on case table

import Foundation

enum CaseStepOption: Int, CaseIterable, Identifiable {
  case firstContact = 1
  case initialEvaluation = 2
  case accompaniment = 3

  var id: Int { rawValue }

  var title: String {
    switch self {
    case .firstContact: return "Primer contacto"
    case .initialEvaluation: return "Evaluación inicial"
    case .accompaniment: return "Acompañamiento"
    }
  }
}

struct UpdateCaseStepRequest: Encodable {
  let stepNumber: Int
}

struct UpdateCaseStepResult: Decodable {
  let success: Bool
}
