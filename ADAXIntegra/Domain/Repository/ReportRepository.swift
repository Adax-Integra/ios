//
//  ReportRepository.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 15/10/26.
//

import Foundation

protocol ReportRepository {
  func downloadReport(from startDate: Date, to endDate: Date) async throws -> URL
}
