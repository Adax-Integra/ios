//
//  RemoteEditCollaboratorRepository.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 19/10/26.
//

import Foundation

struct RemoteEditCollaboratorRepository: EditCollaboratorRepository {
  func editCollaborator(userId: String, request: EditCollaboratorRequest) async throws {
    // The backend answers with the saved user, but the screen reloads the G-10 detail after saving
    _ = try await APIProtocol.patch(
      "/internal-users/\(userId)",
      body: request,
      as: APIResponse<CollaboratorProfile>.self)
  }
}
