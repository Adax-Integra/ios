//
//  RecordStatusViewModel.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 15/10/26.
//

import Combine
import Foundation

final class RecordStatusViewModel: ObservableObject {
  @Published var currentStatus: RecordStatus
  @Published var isUpdating = false

  @Published var errorMessage: String?

  private let recordId: String
  private let externalId: String
  private let repository: RecordRepository

  init(
    recordId: String,
    externalId: String,
    initialStatus: RecordStatus,
    repository: RecordRepository = RemoteRecordRepository()
  ) {
    self.recordId = recordId
    self.externalId = externalId
    self.currentStatus = initialStatus
    self.repository = repository
  }

  @MainActor
  func updateStatus(to newStatus: RecordStatus) async {
    errorMessage = nil

    guard currentStatus.canTransition(to: newStatus) else {
      if newStatus == currentStatus {
        errorMessage = "El expediente ya se encuentra en ese estatus."
      } else {
        errorMessage = "No se puede cambiar de \(currentStatus.label) a \(newStatus.label)."
      }
      return
    }

    isUpdating = true
    defer { isUpdating = false }

    do {
      if newStatus == .completado {
        let cases = try await repository.getRecordFromExternal(
          for: externalId)

        guard cases.allSatisfy({ CaseState(dbValue: $0.state) == .closed }) else {
          errorMessage = "No puedes completar el expediente porque todavía tiene casos abiertos."
          return
        }
      }

      let updatedRaw = try await repository.updateRecordStatus(
        recordId: recordId,
        newStatus: newStatus.rawValue
      )
      currentStatus = RecordStatus(rawValue: updatedRaw) ?? newStatus
    } catch APIError.server(let statusCode, _) where statusCode == 409 {
      errorMessage = "No se puede cambiar a ese estatus desde el actual."
    } catch {
      errorMessage = "No se pudo actualizar el estatus. Intenta de nuevo."
    }
  }
}
