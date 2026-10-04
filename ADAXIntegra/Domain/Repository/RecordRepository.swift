//
//  RecordRepository.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 04/10/26.
//

import Foundation

protocol RecordRepository {
  func getRecordFromExternal(for externalId: String) async throws -> RecordDetails?
}
