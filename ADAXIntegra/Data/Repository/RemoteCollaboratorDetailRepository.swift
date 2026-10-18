//
//  RemoteCollaboratorDetailRepository.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 17/10/26.
//

import Foundation

// Reads one collaborator through the backend (admin only).
// baseURL already ends with /api, so the paths start at /internal-users
struct RemoteCollaboratorDetailRepository: CollaboratorDetailRepository {
  // GET /internal-users/{userId}
  func fetchDetail(userId: String) async throws -> CollaboratorDetail {
    let response = try await APIProtocol.get(
      "/internal-users/\(userId)", as: APIResponse<CollaboratorDetail>.self)

    return response.data
  }

  // GET /internal-users/{userId}/assigned-cases
  func fetchAssignedCases(userId: String) async throws -> CollaboratorAssignedCases {
    let response = try await APIProtocol.get(
      "/internal-users/\(userId)/assigned-cases",
      as: APIResponse<CollaboratorAssignedCases>.self)

    return response.data
  }

  // G-04: PATCH /internal-users/{userId}/status
  func updateStatus(userId: String, isActive: Bool) async throws -> CollaboratorStatusResult {
    let response = try await APIProtocol.patch(
      "/internal-users/\(userId)/status",
      body: UpdateCollaboratorStatusRequest(isActive: isActive),
      as: APIResponse<CollaboratorStatusResult>.self
    )

    return response.data
  }
}
