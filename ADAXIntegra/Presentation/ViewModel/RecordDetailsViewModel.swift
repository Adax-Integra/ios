//
//  RecordDetailsViewModel.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 04/10/26.
//

import Combine
import Foundation

// We don't add @MainActor
final class RecordDetailsViewModel: ObservableObject {
  @Published var recordDetails: RecordDetails?
  @Published var isLoading: Bool = false
  @Published var errorMessage: String?

  private let repository: RecordRepository
  private let externalId: String

  init(externalId: String, repository: RecordRepository = RemoteRecordRepository()) {
    self.externalId = externalId
    self.repository = repository
  }

  func loadRecordDetails() async {
    isLoading = true
    errorMessage = nil

    do {
      let result = try await repository.getRecordFromExternal(for: externalId)
      guard !Task.isCancelled else { return }
      recordDetails = result
      if result == nil {
        errorMessage = "No se ha encontrado ningún caso perteneciente a este expediente"
      }
    } catch {
      guard !Task.isCancelled else { return }
      errorMessage = "Error al cargar los detalles del expediente."
    }

    isLoading = false
  }
}
