//
//  RemoteDocumentsRepository.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 17/10/26.
//

import Foundation

// Reads, uploads and downloads the identity documents of the external user
struct RemoteDocumentsRepository: DocumentsRepository {
  // R-06: GET /external-users/:userId/documents
  func getDocuments(for userId: String) async throws -> SavedDocuments {
    let response = try await APIProtocol.get(
      "/external-users/\(userId)/documents",
      as: APIResponse<SavedDocuments>.self
    )
    return response.data
  }

  // R-06: PATCH /external-users/:userId/documents, the document not sent stays the same
  func uploadDocument(
    _ document: DocumentFile, kind: DocumentKind, for userId: String
  ) async throws -> UploadedDocuments {
    let response = try await APIProtocol.patchMultipart(
      "/external-users/\(userId)/documents",
      files: [Self.fieldName(for: kind): document],
      as: APIResponse<UploadedDocuments>.self
    )
    return response.data
  }

  // The signed URL already carries its permission, so it goes straight to storage without the token
  func downloadDocument(from signedUrl: String, fileName: String) async throws -> URL {
    guard let url = URL(string: signedUrl) else { throw URLError(.badURL) }
    let (data, response) = try await URLSession.shared.data(from: url)
    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
      throw URLError(.badServerResponse)
    }

    // Other apps can upload png, so the extension follows the type storage answers with
    let fileExtension = response.mimeType == "image/png" ? "png" : "jpg"
    let fileURL = FileManager.default.temporaryDirectory
      .appendingPathComponent(fileName)
      .deletingPathExtension()
      .appendingPathExtension(fileExtension)
    try data.write(to: fileURL, options: .atomic)
    return fileURL
  }

  // Same multipart field names as the pre-submission
  private static func fieldName(for kind: DocumentKind) -> String {
    switch kind {
    case .identity: "identity_document"
    case .proofOfAddress: "proof_of_address"
    }
  }
}
