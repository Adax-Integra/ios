//
//  RemoteReportRepository.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 15/10/26.
//

import Foundation

struct RemoteReportRepository: ReportRepository {
  func downloadReport(from startDate: Date, to endDate: Date) async throws -> URL {
    let start = apiDate(startDate)
    let end = apiDate(endDate)

    let data = try await APIProtocol.getData(
      "/reports/export",
      parameters: ["start-date": start, "end-date": end]
    )

    let fileURL = FileManager.default.temporaryDirectory
      .appendingPathComponent("reporte-\(start)-\(end).csv")
    try data.write(to: fileURL, options: .atomic)
    return fileURL
  }

  private func apiDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter.string(from: date)
  }
}
