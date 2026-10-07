//
//  RecordDetailsViewModel.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 04/10/26.
//

import Combine
import Foundation

final class RecordDetailsViewModel: ObservableObject {
  // Initializes an empty array of recordDetails
  @Published var recordDetails = [RecordDetails]()
  @Published var isLoading: Bool = false
  @Published var errorMessage: String?

  private let repository: RecordRepository

  init(repository: RecordRepository = RemoteRecordRepository()) {
    self.repository = repository
  }

  @MainActor
  func loadRecordDetails(for externalId: String) async {
    isLoading = true
    errorMessage = nil
    do {
      let result = try await repository.getRecordFromExternal(for: externalId)
      guard !Task.isCancelled else { return }
      recordDetails = result
      if result.isEmpty {
        errorMessage = "No se ha encontrado ningún caso perteneciente a este expediente"
      }
    } catch {
      guard !Task.isCancelled else { return }
      errorMessage = "Error al cargar los detalles del expediente."
    }
    isLoading = false
  }
}
