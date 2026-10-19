//
//  VerificationReviewRepository.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 17/10/26.
//

import Foundation

protocol VerificationReviewRepository {
  func review(
    userId: String,
    status: String,
    reason: String?
  ) async throws -> VerificationReviewResult
}
