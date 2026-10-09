//
//  ConsentRecord.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 03/10/26.
//

import Foundation

struct ConsentRequestBody: Encodable {
  let policyId: String
}

struct ConsentRecord: Decodable {
  let consentId: String
  let version: String
  let acceptedAt: String
}
