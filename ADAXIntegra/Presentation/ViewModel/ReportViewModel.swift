//
//  ReportViewModel.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 15/10/26.
//

import Combine
import Foundation

final class ReportViewModel: ObservableObject {
  @Published var startDate: Date
  @Published var endDate: Date
  @Published var isLoading = false
  @Published var downloadedFileURL: URL?
  @Published var isShowingShareSheet = false
  @Published var showAlert = false
  @Published var messageAlert = ""

  private let repository: ReportRepository

  init(repository: ReportRepository) {
    self.repository = repository
    let range = ReportPresets.thisMonth.range()
    startDate = range.start
    endDate = range.end
  }

  func applyPreset(_ preset: ReportPresets) {
    let range = preset.range()
    startDate = range.start
    endDate = range.end
  }

  @MainActor
  func generateReport() async {
    if let validationMessage = validateRange() {
      messageAlert = validationMessage
      showAlert = true
      return

    }

    isLoading = true
    defer { isLoading = false }

    do {
      downloadedFileURL = try await repository.downloadReport(from: startDate, to: endDate)
      isShowingShareSheet = true
    } catch {
      messageAlert = "No se pudo generar el reporte. Intenta de nuevo."
      showAlert = true
    }
  }

  private func validateRange() -> String? {
    let calendar = Calendar.current
    let start = calendar.startOfDay(for: startDate)
    let end = calendar.startOfDay(for: endDate)

    if end < start {
      return "La fecha de fin no puede ser anterior a la de inicio."
    }
    if let maxEnd = calendar.date(byAdding: .year, value: 1, to: start), end > maxEnd {
      return "El rango no puede ser mayor a un año."
    }
    return nil
  }
}
