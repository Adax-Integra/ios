//
//  RemoteRecordRepository.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 04/10/26.
//

struct RecordStatusResponse: Decodable {
  let recordId: String
  let status: String

  enum CodingKeys: String, CodingKey {
    case recordId = "record_id"
    case status
  }
}

struct RemoteRecordRepository: RecordRepository {

  func getRecordFromExternal(for externalId: String) async throws -> [RecordDetails] {
    let response = try await APIProtocol.get(
      "/internal-users/\(externalId)/allCases",
      as: APIResponse<[RecordDetails]>.self)
    return response.data
  }

  func updateRecordStatus(recordId: String, newStatus: String) async throws -> String {
    let response = try await APIProtocol.patch(
      "/records/\(recordId)/status",
      body: ["status": newStatus],
      as: APIResponse<RecordStatusResponse>.self)
    return response.data.status
  }
}
