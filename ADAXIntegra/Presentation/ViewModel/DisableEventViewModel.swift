//
//  DisableEventViewModel.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 14/10/26.
//

import Combine
import Foundation

// E-03: confirmation, request and result of disabling one event
@MainActor
final class DisableEventViewModel: ObservableObject {
  @Published var isShowingConfirmation = false
  @Published var isShowingSuccess = false
  @Published var isDisabling = false
  @Published var toastMessage = ""
  @Published var showToast = false

  // E-03: the list has many events, so the one to disable is saved when it is tapped
  private var eventId: String?
  var disableEventUseCase: DisableEventUseCaseProtocol

  init(disableEventUseCase: DisableEventUseCaseProtocol? = nil) {
    //Built here so it runs on the main actor, same as other ViewModels
    self.disableEventUseCase =
      disableEventUseCase ?? DisableEventUseCase(repository: RemoteEventRepository())
  }

  func onDisableTapped(eventId: String) {
    self.eventId = eventId
    isShowingConfirmation = true
  }

  func onCancel() {
    eventId = nil
    isShowingConfirmation = false
  }

  func confirm() async {
    guard let eventId else { return }
    isDisabling = true

    do {
      _ = try await disableEventUseCase.execute(eventId: eventId)
      isShowingSuccess = true
    } catch {
      toastMessage = message(for: error)
      showToast = true
    }

    self.eventId = nil
    isShowingConfirmation = false
    isDisabling = false
  }

  private func message(for error: Error) -> String {
    guard case APIError.server(let statusCode, _) = error else {
      return "No pudimos deshabilitar el evento. Revisa tu conexión e intenta de nuevo."
    }

    // The backend answers 409 when the event was already disabled or does not exist
    if statusCode == 409 {
      return "Este evento ya estaba deshabilitado o ya no existe."
    }
    return "No pudimos deshabilitar el evento. Intenta de nuevo más tarde."
  }
}
