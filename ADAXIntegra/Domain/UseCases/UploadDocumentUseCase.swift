//
//  UploadDocumentUseCase.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 17/10/26.
//

import Foundation

protocol UploadDocumentUseCaseProtocol {
  func uploadDocument(
    _ document: DocumentFile, kind: DocumentKind, for userId: String
  ) async throws -> UploadedDocuments
}

class UploadDocumentUseCase: UploadDocumentUseCaseProtocol {
  let dataRepository: DocumentsRepository

  init(dataRepository: DocumentsRepository) {
    self.dataRepository = dataRepository
  }

  func uploadDocument(
    _ document: DocumentFile, kind: DocumentKind, for userId: String
  ) async throws -> UploadedDocuments {
    try await dataRepository.uploadDocument(document, kind: kind, for: userId)
  }
}
