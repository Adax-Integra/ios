//
//  CollaboratorRepository.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 24/09/26.
//

import Foundation

protocol CollaboratorRepository {
    
    func createCollaborator(_ collaborator: NewCollaborator) async throws -> Collaborator
}
