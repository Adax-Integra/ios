//
//  GetDocumentsUseCase.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 17/10/26.
//

import Foundation

protocol GetDocumentsUseCaseProtocol {
  func getDocuments(for userId: String) async throws -> SavedDocuments
  func downloadDocument(from signedUrl: String, fileName: String) async throws -> URL
}

class GetDocumentsUseCase: GetDocumentsUseCaseProtocol {
  let dataRepository: DocumentsRepository

  init(dataRepository: DocumentsRepository) {
    self.dataRepository = dataRepository
  }

  func getDocuments(for userId: String) async throws -> SavedDocuments {
    try await dataRepository.getDocuments(for: userId)
  }

  func downloadDocument(from signedUrl: String, fileName: String) async throws -> URL {
    try await dataRepository.downloadDocument(from: signedUrl, fileName: fileName)
  }
}
