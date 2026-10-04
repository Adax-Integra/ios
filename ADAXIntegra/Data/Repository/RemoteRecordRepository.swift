//
//  RemoteRecordRepository.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 04/10/26.
//

struct RemoteRecordRepository: RecordRepository {
  func getRecordFromExternal(for externalId: String) async throws -> RecordDetails? {
    let response = try await APIProtocol.get(
      "/internal-users/\(externalId)/allCases",
      as: APIResponse<RecordDetails>.self)
    return response.data
  }
}
