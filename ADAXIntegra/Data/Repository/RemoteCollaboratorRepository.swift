//
//  RemoteCollaboratorRepository.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 02/10/26.
//

import Foundation

// Manages all collaborators while talcking with the backend
struct RemoteCollaboratorRepository: CollaboratorRepository {

  func createCollaborator(_ collaborator: NewCollaborator) async throws -> Collaborator {
    let response = try await APIProtocol.post(
      "/internal-users", body: collaborator, as: APIResponse<Collaborator>.self
    )
    return response.data
  }

  // G-06: GET /internal-users, newest first
  func listCollaborators() async throws -> [CollaboratorListItem] {
    let response = try await APIProtocol.get(
      "/internal-users", as: APIResponse<[CollaboratorListItem]>.self
    )
    return response.data
  }
}
