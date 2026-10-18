//
//  DocumentsRepository.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 17/10/26.
//

import Foundation

protocol DocumentsRepository {
  // R-06: documents the external user already uploaded
  func getDocuments(for userId: String) async throws -> SavedDocuments

  // R-06: uploads or replaces one document of the external user
  func uploadDocument(
    _ document: DocumentFile, kind: DocumentKind, for userId: String
  ) async throws -> UploadedDocuments

  // Saves the document of a signed URL on the phone and returns where it was saved
  func downloadDocument(from signedUrl: String, fileName: String) async throws -> URL

  // B-02 / V-13: staff views the documents of an external user's record
  func getStaffDocuments(for userId: String) async throws -> SavedDocuments
}
