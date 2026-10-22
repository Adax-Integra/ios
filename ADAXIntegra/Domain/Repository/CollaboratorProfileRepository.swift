//
//  CollaboratorProfileRepository.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 16/10/26.
//

import Foundation

protocol CollaboratorProfileRepository {
    func getCollaboratorProfile(for userId: String) async throws -> CollaboratorProfile
    
    func updateCollaboratorProfile(
        for userId: String,
        with request: UpdateCollaboratorProfileRequest
    ) async throws -> CollaboratorProfile
}
