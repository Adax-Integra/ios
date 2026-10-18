//
//  CreateExternalCaseUseCase.swift
//  ADAXIntegra
//
//  Created by Lakshmi Jara on 18/10/26.
//

import Foundation

// R-11: creates a case for an external user from an internal account
protocol CreateExternalCaseUseCaseProtocol {
  func createCase(_ newCase: NewCase, userId: String) async -> String?
}

class CreateExternalCaseUseCase: CreateExternalCaseUseCaseProtocol {
  let dataRepository: CaseRepository

  init(dataRepository: CaseRepository) {
    self.dataRepository = dataRepository
  }

  func createCase(_ newCase: NewCase, userId: String) async -> String? {
    await dataRepository.createCaseForExternalUser(newCase, userId: userId)
  }
}
