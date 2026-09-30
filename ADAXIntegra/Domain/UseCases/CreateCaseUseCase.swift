//
//  CreateCaseUseCase.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 23/09/26.
//

import Foundation

// Exposed as a protocol so the ViewModel can receive a fake in previews and tests
protocol CreateCaseUseCaseProtocol {
  func createCase(_ newCase: NewCase, userId: String) async -> String?
}

// Business rule for HU R-02: registers a new case for the logged-in user.
// Field validation lives in the ViewModel (isFormValid) and in each field's maxLength
class CreateCaseUseCase: CreateCaseUseCaseProtocol {
  let dataRepository: CaseRepository

  init(dataRepository: CaseRepository) {
    self.dataRepository = dataRepository
  }

  func createCase(_ newCase: NewCase, userId: String) async -> String? {
    await dataRepository.createCase(newCase, userId: userId)
  }
}
