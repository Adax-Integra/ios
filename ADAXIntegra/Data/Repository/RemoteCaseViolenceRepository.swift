//
//  RemoteCaseViolenceRepository.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 17/10/26.
//

import Foundation

struct RemoteCaseViolenceRepository: CaseViolenceRepository {
  // catalgo of violences types

  func listViolenceTypes() async throws -> [ViolenceType] {
    let response = try await APIProtocol.get(
      "/violences-types",
      as: APIResponse<[ViolenceType]>.self
    )
    return response.data
  }

  // sends the final list as an empty list removes every violence type if the presented case
  func assignViolenceTypes(caseId: String, violenceIds: [String]) async throws
    -> ViolenceTypesAssignment
  {
    let response = try await APIProtocol.patch(
      "/cases/\(caseId)/violence-types",
      body: AssignViolenceTypesRequest(violenceIds: violenceIds),
      as: APIResponse<ViolenceTypesAssignment>.self
    )
    return response.data
  }
}
