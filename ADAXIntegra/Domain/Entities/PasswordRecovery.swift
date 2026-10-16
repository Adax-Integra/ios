//
//  PasswordRecovery.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 12/10/26.
//

import Foundation

// Data sent to request the recovery code
struct ForgotPasswordRequest: Encodable {
  let email: String
}

// Data sent to request a change of password
struct ResetPasswordRequest: Encodable {
  let email: String
  let code: String
  let newPassword: String
}

// response to doth endPoints
struct PasswordRecoveryResponse: Decodable {
  let message: String?
}
