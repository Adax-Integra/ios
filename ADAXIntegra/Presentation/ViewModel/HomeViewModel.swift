//
//  HomeViewModel.swift
//  ADAXIntegra
//
//  Created by Lakshmi Jara on 13/10/26.
//

import Combine
import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
  @Published private(set) var records: [RecordListItem] = []
  @Published private(set) var isLoading = false
  @Published private(set) var errorMessage: String?

  private let getRecentRecordsUseCase: GetRecentRecordsUseCaseProtocol

  init(
    getRecentRecordsUseCase: GetRecentRecordsUseCaseProtocol? = nil
  ) {
    self.getRecentRecordsUseCase =
      getRecentRecordsUseCase
      ?? GetRecentRecordsUseCase(
        dataRepository: RemoteRecordListRepository()
      )
  }

  func loadRecords() async {
    guard !isLoading else { return }

    isLoading = true
    errorMessage = nil
    defer { isLoading = false }

    do {
      let result = try await getRecentRecordsUseCase.getRecentRecords()
      try Task.checkCancellation()
      records = result
    } catch {
      guard !Task.isCancelled else { return }
      errorMessage = "No se pudieron cargar los expedientes."
    }
  }
}
