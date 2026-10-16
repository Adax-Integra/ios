//
//  ViewAndEditProfileUseCase.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 15/10/26.
//

import Foundation

protocol ViewAndEditProfileUseCaseProtocol {
  func getStaffProfile(for userId: String) async throws -> ProfileStaff
  func getExternalProfile(for userId: String) async throws -> ProfileExternal
  func editProfile(for userId: String, with request: UpdateProfileRequest) async throws
}

/*
 R-04: the logged-in user views and edits their own profile
 Admin and internal users edit name, last name and phone, external users also edit their address
*/
class ViewAndEditProfileUseCase: ViewAndEditProfileUseCaseProtocol {
  let dataRepository: ViewAndEditProfileRepository

  init(dataRepository: ViewAndEditProfileRepository) {
    self.dataRepository = dataRepository
  }

  func getStaffProfile(for userId: String) async throws -> ProfileStaff {
    try await dataRepository.getStaffProfile(for: userId)
  }

  func getExternalProfile(for userId: String) async throws -> ProfileExternal {
    try await dataRepository.getExternalProfile(for: userId)
  }

  func editProfile(for userId: String, with request: UpdateProfileRequest) async throws {
    try await dataRepository.editProfile(for: userId, with: request)
  }
}
