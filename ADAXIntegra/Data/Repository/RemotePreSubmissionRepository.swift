//
//  RemotePreSubmissionRepository.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 01/10/26.
//

import Foundation

struct RemotePreSubmissionRepository: PreSubmissionRepository {
  func getPreSubmission(for userId: String) async throws -> PreSubmission {
    let response = try await APIProtocol.get(
      "/external-users/\(userId)/pre-submission",
      as: APIResponse<PreSubmission>.self)
    return response.data
  }

  func editPreSubmission(
    for userId: String,
    with preSubmission: PreSubmission,
    identityDocument: DocumentFile?,
    proofOfAddress: DocumentFile?
  ) async throws -> PreSubmission {
    /*
     The PUT body is multipart: "profile" and "address" are JSON strings.
     Profile and Address already encoded but the need a decoding sent to the backend,
     because they are sent as JSON strings.
    */
    let encoder = JSONEncoder()
    let profile = String(decoding: try encoder.encode(preSubmission.profile), as: UTF8.self)
    let address = String(decoding: try encoder.encode(preSubmission.address), as: UTF8.self)

    // Only the documents the user picked are sent
    var files: [String: DocumentFile] = [:]
    if let identityDocument { files["identity_document"] = identityDocument }
    if let proofOfAddress { files["proof_of_address"] = proofOfAddress }

    let response = try await APIProtocol.putMultipart(
      "/external-users/\(userId)/pre-submission",
      fields: ["profile": profile, "address": address],
      files: files,
      as: APIResponse<PreSubmission>.self)
    return response.data
  }
}
