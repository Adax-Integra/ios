//
//  DeleteCommentUseCase.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 07/10/26.
//
//  UseCase for US B-02 that soft-deletes a comment (Undo action)
//

import Foundation

protocol DeleteCommentUseCaseProtocol {
    // Deletes a comment by its commentId if the  user is its author
    func execute(commentId: String) async throws
}

// Handles the business logic for soft deleting comments.
class DeleteCommentUseCase: DeleteCommentUseCaseProtocol {
    let repository: CommentRepository

    init(repository: CommentRepository = RemoteCommentRepository()) {
        self.repository = repository
    }

    func execute(commentId: String) async throws {
        try await repository.deleteComment(commentId: commentId)
    }
}
