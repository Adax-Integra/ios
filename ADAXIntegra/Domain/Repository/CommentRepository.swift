//
//  CommentRepository.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 07/10/26.
//
//  Protocol contract for fetching creating and deleting comments (US B-02)
//

import Foundation

protocol CommentRepository {
    func getComments(caseId: String, limit: Int?) async throws -> [Comment]
    func createComment(caseId: String, content: String) async throws -> Comment
    func deleteComment(commentId: String) async throws
}
