//
//  RemoteVerificationReviewRepository.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 17/10/26.
//

import Foundation

struct RemoteVerificationReviewRepository: VerificationReviewRepository {
    func review(
        userId: String,
        status: String,
        reason: String?
    ) async throws -> VerificationReviewResult {
        let response = try await APIProtocol.patch(
            "/internal-users/external-users/\(userId)/verification",
            body: ReviewVerificationRequest(status: status, reason: reason),
            as: APIResponse<VerificationReviewResult>.self
        )
        return response.data
    }
}
