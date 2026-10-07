//
//  RemoteCommentRepository.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 07/10/26.
// Connects comments to the backend using API protocol
//

import Foundation

struct RemoteCommentRepository: CommentRepository {

    // Fetches the list of comments for a specific case, ordered newest first
    func getComments(caseId: String, limit: Int? = nil) async throws -> [Comment] {
        var path = "/cases/\(caseId)/comments"
        if let limit = limit {
            path += "?limit=\(limit)"
        }

        let response = try await APIProtocol.get(
            path,
            as: APIResponse<[Comment]>.self
        )
        return response.data
    }

    // Sends a request to attach a new comment to a case
    func createComment(caseId: String, content: String) async throws -> Comment {
        let requestBody = CreateCommentModel(content: content)
        
        let response = try await APIProtocol.post(
            "/cases/\(caseId)/comments",
            body: requestBody,
            as: APIResponse<Comment>.self
        )
        return response.data
    }

    // Performs a soft delete on a specific comment 
    func deleteComment(commentId: String) async throws {
        try await APIProtocol.delete("/comments/\(commentId)")
    }
}

