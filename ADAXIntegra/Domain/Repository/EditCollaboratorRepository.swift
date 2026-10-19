//
//  EditCollaboratorRepository.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 19/10/26.
//


import Foundation

// G-11 where the admin edits the data of a collaborator
protocol EditCollaboratorRepository {
  func editCollaborator(userId: String, request: EditCollaboratorRequest) async throws
}
