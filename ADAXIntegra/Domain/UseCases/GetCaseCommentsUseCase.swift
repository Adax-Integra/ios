//
//  GetCaseCommentsUseCase.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 07/10/26.
//  UseCase for US B-02 that uses Get to fetch all comments attached to a specific case
//

import Foundation

protocol GetCaseCommentsUseCaseProtocol {
    // Fetches the comments for a given caseId with an optional limit parameter
    func execute(caseId: String, limit: Int?) async throws -> [Comment]
}

// Handles the business logic for retrieving case comments by delegating to the repository
class GetCaseCommentsUseCase: GetCaseCommentsUseCaseProtocol {
    let repository: CommentRepository

    init(repository: CommentRepository = RemoteCommentRepository()) {
        self.repository = repository
    }

    func execute(caseId: String, limit: Int? = nil) async throws -> [Comment] {
        try await repository.getComments(caseId: caseId, limit: limit)
    }
}

