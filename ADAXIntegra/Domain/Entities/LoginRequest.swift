//
//  LoginRequest.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 03/10/26.
//

import Foundation

struct LoginRequestBody: Encodable {
  let email: String
  let password: String
}
