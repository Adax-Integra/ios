//
//  ReviewVerificationRequest.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 17/10/26.
//

import Foundation

struct ReviewVerificationRequest: Encodable {
  let status: String
  let reason: String?
}
