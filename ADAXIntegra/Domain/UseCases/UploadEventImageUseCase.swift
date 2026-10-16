//
//  UploadEventImageUseCase.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 15/10/26.
//

import Foundation

protocol UploadEventImageUseCaseProtocol {
  func uploadEventImage(eventId: String, image: DocumentFile) async throws -> EventImage
}

class UploadEventImageUseCase: UploadEventImageUseCaseProtocol {
  let dataRepository: EventRepository

  init(dataRepository: EventRepository) {
    self.dataRepository = dataRepository
  }

  func uploadEventImage(eventId: String, image: DocumentFile) async throws -> EventImage {
    try await dataRepository.uploadEventImage(eventId: eventId, image: image)
  }
}
