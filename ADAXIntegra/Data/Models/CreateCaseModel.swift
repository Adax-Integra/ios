//
//  CreateCaseModel.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 28/09/26.
//

import Foundation

// Body of POST /external-users/{userId}/cases
// Property names must match the keys the backend validator reads
struct CreateCaseRequest: Encodable {
  let writtenDescription: String
  let writtenHelpsWanted: String
  let hasExternalSupport: Bool

  init(from entity: CaseEntity) {
    writtenDescription = entity.description
    writtenHelpsWanted = entity.helpDetails
    hasExternalSupport = entity.hasExternalSupport
  }
}

// "data" of the 201 response. Only caseId is decoded: the response lacks
// updatedAt and violenceTypes, so it cannot be decoded as the Case entity
struct CreatedCaseModel: Decodable {
  let caseId: String
}
