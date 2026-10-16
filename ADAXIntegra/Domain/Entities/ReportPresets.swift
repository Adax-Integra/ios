//
//  ReportPresets.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 15/10/26.
//

import Foundation

enum ReportPresets: CaseIterable {
  case thisMonth, lastMonth, lastTrimester

  var title: String {
    switch self {
    case .thisMonth: return "Este mes"
    case .lastMonth: return "Mes anterior"
    case .lastTrimester: return "Trimestre anterior"
    }
  }

  func range(now: Date = Date(), calendar: Calendar = .current) -> (start: Date, end: Date) {
    let startOfThisMonth = calendar.dateInterval(of: .month, for: now)!.start

    switch self {
    case .thisMonth:
      return (startOfThisMonth, now)

    case .lastMonth:
      let start = calendar.date(byAdding: .month, value: -1, to: startOfThisMonth)!
      let end = calendar.date(byAdding: .day, value: -1, to: startOfThisMonth)!
      return (start, end)

    // last trimester (ene-mar, abr-jun, jul-sep, oct-dic)
    case .lastTrimester:
      let month = calendar.component(.month, from: now)
      let firstMonthOfQuarter = ((month - 1) / 3) * 3 + 1
      var components = calendar.dateComponents([.year], from: now)
      components.month = firstMonthOfQuarter
      components.day = 1
      let startOfThisQuarter = calendar.date(from: components)!
      let start = calendar.date(byAdding: .month, value: -3, to: startOfThisQuarter)!
      let end = calendar.date(byAdding: .day, value: -1, to: startOfThisQuarter)!
      return (start, end)
    }
  }
}
