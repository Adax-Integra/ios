//
//  UpdateCollaboratorProfileUseCase.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 16/10/26.
//

import Foundation

protocol UpdateCollaboratorProfileUseCaseProtocol {
    func updateCollaboratorProfile(
        for userId: String,
        with request: UpdateCollaboratorProfileRequest
    ) async throws -> CollaboratorProfile
}

class UpdateCollaboratorProfileUseCase: UpdateCollaboratorProfileUseCaseProtocol {
    let dataRepository: CollaboratorProfileRepository
    
    init(dataRepository: CollaboratorProfileRepository) {
        self.dataRepository = dataRepository
    }
    
    func updateCollaboratorProfile(
        for userId: String,
        with request: UpdateCollaboratorProfileRequest
    ) async throws -> CollaboratorProfile {
        try await dataRepository.updateCollaboratorProfile(for: userId, with: request)
    }
}
