//
//  EmailVerification.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 14/10/26.
//

import Foundation

// the reponse is the session, so it resues LoginResult

struct VerifyEmailRequest: Encodable {
  let email: String
  let code: String
}

// Data sent to the verification code
struct ResendVerificationRequest: Encodable {
  let email: String
}

// Response of the resend verification
struct ResendVerificationResponse: Decodable {
  let message: String?
}
