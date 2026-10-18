//
//  CollaboratorDetailRepository.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 17/10/26.
//

import Foundation

// Reads the detail and the assigned cases of one collaborator for us G-10
protocol CollaboratorDetailRepository {
  func fetchDetail(userId: String) async throws -> CollaboratorDetail
  func fetchAssignedCases(userId: String) async throws -> CollaboratorAssignedCases
}
