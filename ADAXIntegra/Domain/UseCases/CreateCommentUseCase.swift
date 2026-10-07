//
//  CreateCommentUseCase.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 07/10/26.
//
//  UseCase for US B-02 that posts a new comment to a specific case
//

import Foundation

protocol CreateCommentUseCaseProtocol {
    // Posts a new comment to a specific case after validating its content (not more than 5000 caracters)
    func execute(caseId: String, content: String) async throws -> Comment
}

/// Handles the business logic and basic domain validation for creating comments.
class CreateCommentUseCase: CreateCommentUseCaseProtocol {
    let repository: CommentRepository

    init(repository: CommentRepository = RemoteCommentRepository()) {
        self.repository = repository
    }

    func execute(caseId: String, content: String) async throws -> Comment {
        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            throw NSError(
                domain: "CreateCommentUseCase",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey: "El comentario no puede estar vacío."]
            )
        }
        return try await repository.createComment(caseId: caseId, content: trimmed)
    }
}

