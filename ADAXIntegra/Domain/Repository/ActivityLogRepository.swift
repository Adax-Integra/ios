//
//  ActivityLogRepository.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 18/10/26.
//

import Foundation

// Repository reads the activity log
protocol ActivityLogRepository {
  func listActivityLog(page: Int, from: Date?, to: Date?) async throws -> ActivityLogResult
}
