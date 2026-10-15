//
//  ViewAndEditProfileRepository.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 15/10/26.
//

import Foundation

protocol ViewAndEditProfileRepository {
  func getStaffProfile(for userId: String) async throws -> ProfileStaff
  func editStaffProfile(_ profile: ProfileStaff) async throws -> ProfileStaff

  func getExternalProfile(for userId: String) async throws -> ProfileExternal
  func editExternalProfile(_ profile: ProfileExternal) async throws -> ProfileExternal
}
