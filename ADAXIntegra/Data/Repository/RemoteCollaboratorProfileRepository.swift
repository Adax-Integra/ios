//
//  RemoteCollaboratorProfileRepository.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 16/10/26.
//

import Foundation

struct RemoteCollaboratorProfileRepository: CollaboratorProfileRepository {
    func getCollaboratorProfile(for userId: String) async throws -> CollaboratorProfile {
        let response = try await APIProtocol.get(
            "/internal-users/\(userId)",
            as: APIResponse<CollaboratorProfile>.self)
        return response.data
    }
    
    func updateCollaboratorProfile(
        for userId: String,
        with request: UpdateCollaboratorProfileRequest
    ) async throws -> CollaboratorProfile {
        let response = try await APIProtocol.patch(
            "/internal-users/\(userId)",
            body: request,
            as: APIResponse<CollaboratorProfile>.self)
        return response.data
    }
}
