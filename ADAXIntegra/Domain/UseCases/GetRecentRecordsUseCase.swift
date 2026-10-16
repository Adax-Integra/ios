//
//  GetRecentRecordsUseCase.swift
//  ADAXIntegra
//
//  Created by Lakshmi Jara on 13/10/26.
//

import Foundation

protocol GetRecentRecordsUseCaseProtocol {
  func getRecentRecords() async throws -> [RecordListItem]
}

class GetRecentRecordsUseCase: GetRecentRecordsUseCaseProtocol {
  let dataRepository: RecordListRepository

  init(dataRepository: RecordListRepository) {
    self.dataRepository = dataRepository
  }

  func getRecentRecords() async throws -> [RecordListItem] {
    var records: [RecordListItem] = []
    var page = 1

    // loads all pages
    while true {
      try Task.checkCancellation()

      let result = try await dataRepository.listRecords(
        page: page,
        search: "",
        hasOpenCases: nil,
        status: nil
      )

      if result.records.isEmpty {
        guard records.count >= result.total else {
          throw URLError(.badServerResponse)
        }
        break
      }

      records.append(contentsOf: result.records)

      if records.count >= result.total {
        break
      }

      page += 1
    }

    return Array(
      records
        .filter { $0.updatedDate != nil }
        .sorted {
          ($0.updatedDate ?? .distantPast) > ($1.updatedDate ?? .distantPast)
        }
        .prefix(3)
    )
  }
}
