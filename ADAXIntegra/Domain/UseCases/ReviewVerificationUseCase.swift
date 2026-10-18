//
//  ReviewVerificationUseCase.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 17/10/26.
//

import Foundation

protocol ReviewVerificationUseCaseProtocol {
    func review(
        userId: String,
        status: VerificationStatus,
        reason: String?
    ) async throws -> VerificationReviewResult
}

class ReviewVerificationUseCase: ReviewVerificationUseCaseProtocol {
    let dataRepository: VerificationReviewRepository
    
    init(dataRepository: VerificationReviewRepository) {
        self.dataRepository = dataRepository
    }
    
    func review(
        userId: String,
        status: VerificationStatus,
        reason: String?
    ) async throws -> VerificationReviewResult {
        try await dataRepository.review(
            userId: userId,
            status: status.rawValue,
            reason: reason
        )
    }
}
