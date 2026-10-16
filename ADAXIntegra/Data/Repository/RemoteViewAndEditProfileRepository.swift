//
//  RemoteViewAndEditProfileRepository.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 15/10/26.
//

import Foundation

// Backend implementation of ViewAndEditProfileRepository (R-04)
struct RemoteViewAndEditProfileRepository: ViewAndEditProfileRepository {
  // The edit endpoint only sends the address to external users, so both use it
  func getStaffProfile(for userId: String) async throws -> ProfileStaff {
    let response = try await APIProtocol.get(
      "/profile/\(userId)/edit", as: APIResponse<ProfileStaff>.self)
    return response.data
  }

  func getExternalProfile(for userId: String) async throws -> ProfileExternal {
    let response = try await APIProtocol.get(
      "/profile/\(userId)/edit", as: APIResponse<ProfileExternal>.self)
    return response.data
  }

  // PATCH answers with a message, the app reloads the profile with a GET
  func editProfile(for userId: String, with request: UpdateProfileRequest) async throws {
    _ = try await APIProtocol.patch(
      "/profile/\(userId)",
      body: request,
      as: APIResponse<[String: String]>.self)
  }
}
