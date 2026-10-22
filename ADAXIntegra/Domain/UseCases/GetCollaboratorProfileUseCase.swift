//
//  GetCollaboratorProfileUseCase.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 16/10/26.
//

import Foundation

protocol GetCollaboratorProfileUseCaseProtocol {
    func getCollaboratorProfile(for userId: String) async throws -> CollaboratorProfile
}

class GetCollaboratorProfileUseCase: GetCollaboratorProfileUseCaseProtocol {
    let dataRepository: CollaboratorProfileRepository
    
    init(dataRepository: CollaboratorProfileRepository) {
        self.dataRepository = dataRepository
    }
    
    func getCollaboratorProfile(for userId: String) async throws -> CollaboratorProfile {
        try await dataRepository.getCollaboratorProfile(for: userId)
    }
}
