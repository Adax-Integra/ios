//
//  ChangeLogViewModel.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 18/10/26.
//


import Combine
import Foundation

// Logs of the same day, shown under one header
struct ActivityLogSection: Identifiable {
  let id: Date
  let title: String
  let items: [ActivityLogItem]
}

@MainActor
final class ChangeLogViewModel: ObservableObject {
  // Logs loaded so far (all the pages already requested)
  @Published private(set) var logs: [ActivityLogItem] = []
  @Published private(set) var total = 0
  @Published private(set) var isLoading = false
  @Published var errorMessage: String?
// Only letters and single spaces are accepted. Anything else (enters, numbers,
// symbols, emojis) is removed as soon as it is typed
  @Published var searchText = "" {
        didSet {
          let clean = Self.sanitizeSearch(searchText)
          if clean != searchText { searchText = clean }
        }
      }

  // Date range sent to the backend as from / to
  @Published private(set) var startDate: Date?
  @Published private(set) var endDate: Date?

  private var currentPage = 1
  private let useCase: ListActivityLogUseCaseProtocol

  init(useCase: ListActivityLogUseCaseProtocol = ListActivityLogUseCase()) {
    self.useCase = useCase
  }

  var hasActiveFilter: Bool { startDate != nil || endDate != nil }
  var canLoadMore: Bool { logs.count < total }

  var filteredLogs: [ActivityLogItem] {
    let text = searchText.trimmingCharacters(in: .whitespaces)
    guard !text.isEmpty else { return logs }
    return logs.filter {
      $0.actorName.localizedCaseInsensitiveContains(text)
        || $0.target.localizedCaseInsensitiveContains(text)
        || $0.actionLabel.localizedCaseInsensitiveContains(text)
        || $0.description.localizedCaseInsensitiveContains(text)
    }
  }

  // Logs come newest first
  var sections: [ActivityLogSection] {
    let calendar = Calendar.current
    var result: [ActivityLogSection] = []

    for log in filteredLogs {
      let day = calendar.startOfDay(for: log.date)
      if let last = result.last, last.id == day {
        // Same day as the previous log  adds it to the current section
        result[result.count - 1] = ActivityLogSection(
          id: day, title: last.title, items: last.items + [log])
      } else {
        // If its a new day it starts a new section
        result.append(
          ActivityLogSection(id: day, title: Self.title(for: day), items: [log]))
      }
    }
    return result
  }

  func refresh() async {
    currentPage = 1
    await load(reset: true)
  }

  // wen the last row appears the next page is requested
  func loadMoreIfNeeded(currentItem: ActivityLogItem) async {
    guard currentItem.id == logs.last?.id else { return }
    guard canLoadMore, !isLoading else { return }
    currentPage += 1
    await load(reset: false)
  }

  func applyFilter(start: Date, end: Date) async {
    let calendar = Calendar.current
    startDate = calendar.startOfDay(for: start)
    endDate = calendar.date(
      byAdding: DateComponents(day: 1, second: -1),
      to: calendar.startOfDay(for: end))
    await refresh()
  }

  func clearFilter() async {
    startDate = nil
    endDate = nil
    await refresh()
  }

  private func load(reset: Bool) async {
    isLoading = true
    errorMessage = nil

    do {
      let result = try await useCase.listActivityLog(
        page: currentPage, from: startDate, to: endDate)
      guard !Task.isCancelled else {
        isLoading = false
        return
      }

      if reset {
        logs = result.logs
      } else {
        logs.append(contentsOf: result.logs)
      }
      total = result.total
    } catch {
      guard !Task.isCancelled else {
        isLoading = false
        return
      }
      if !reset { currentPage -= 1 }
      errorMessage = "No se pudo cargar la bitácora de cambios."
      print("Error al cargar la bitácora", error)
    }

    isLoading = false
  }

  // Header text of each day group
  private static func title(for day: Date) -> String {
    let calendar = Calendar.current
    if calendar.isDateInToday(day) { return "Hoy" }
    if calendar.isDateInYesterday(day) { return "Ayer" }
    return day.dateString
  }

  private static func sanitizeSearch(_ text: String) -> String {
        var result = ""
        for char in text {
          guard char.isLetter || char == " " else { continue }
          if char == " " && (result.isEmpty || result.last == " ") { continue }
          result.append(char)
        }
        return String(result.prefix(40))
      }
}
 
