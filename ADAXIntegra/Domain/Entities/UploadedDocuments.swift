//
//  UploadedDocuments.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 17/10/26.
//

import Foundation

// R-06: answer of the upload, the URLs are signed and expire after 15 minutes
struct UploadedDocuments: Decodable {
  let documentId: String?
  let identityDocumentUrl: String?
  let proofOfAddressUrl: String?

  enum CodingKeys: String, CodingKey {
    case documentId = "document_id"
    case identityDocumentUrl = "identity_document_url"
    case proofOfAddressUrl = "proof_of_address_url"
  }
}

// R-06: documents the external user already uploaded, nil when it was never uploaded
struct SavedDocuments: Decodable {
  let identityDocument: SavedDocument?
  let proofOfAddress: SavedDocument?

  enum CodingKeys: String, CodingKey {
    case identityDocument = "identity_document"
    case proofOfAddress = "proof_of_address"
  }
}

struct SavedDocument: Decodable {
  // Signed URL that expires after 15 minutes, nil when storage could not sign it
  let url: String?
}
