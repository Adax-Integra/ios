//
//  ChangePasswordUseCase.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 07/10/26.
//

import Foundation

protocol ChangePasswordUseCaseProtocol {
  func changePassword(currentPassword: String, newPassword: String, confirmPassword: String)
    async throws -> ChangePasswordResult
}

class ChangePasswordUseCase: ChangePasswordUseCaseProtocol {
  let dataRepository: AuthRepository

  init(dataRepository: AuthRepository) {
    self.dataRepository = dataRepository
  }

  func changePassword(currentPassword: String, newPassword: String, confirmPassword: String)
    async throws -> ChangePasswordResult
  {
    try await dataRepository.changePassword(
      currentPassword: currentPassword, newPassword: newPassword, confirmPassword: confirmPassword)
  }
}
