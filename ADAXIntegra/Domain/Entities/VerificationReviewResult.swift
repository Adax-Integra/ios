//
//  VerificationReviewResult.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 17/10/26.
//

import Foundation

struct VerificationReviewResult: Decodable {
    let userId: String
    let verificationStatus: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case verificationStatus = "verification_status"
    }
}
