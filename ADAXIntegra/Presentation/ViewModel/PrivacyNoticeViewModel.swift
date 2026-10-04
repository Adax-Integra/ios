//
//  PrivacyNoticeViewModel.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 03/10/26.
//

import Combine
import Foundation

@MainActor
final class PrivacyNoticeViewModel: ObservableObject {
  @Published var hasAccepted = false
  @Published var policy: PrivacyPolicy?
  @Published var isLoading = false
  @Published var showAlert = false
  @Published var messageAlert = ""

  private let getCurrentPolicyUseCase: GetCurrentPolicyUseCaseProtocol

  init(getCurrentPolicyUseCase: GetCurrentPolicyUseCaseProtocol? = nil) {
    self.getCurrentPolicyUseCase =
      getCurrentPolicyUseCase
      ?? GetCurrentPolicyUseCase(dataRepository: RemotePrivacyPolicyRepository())
  }

  // Consent only counts for a notice that actually loaded: its id is what gets registered
  var canContinue: Bool {
    hasAccepted && policy != nil
  }

  func loadCurrentPolicy() async {
    isLoading = true

    do {
      policy = try await getCurrentPolicyUseCase.getCurrentPolicy()
    } catch {
      messageAlert =
        "No pudimos cargar el aviso de privacidad. Revisa tu conexión e intenta de nuevo."
      showAlert = true
    }

    isLoading = false
  }
  func showDocumentUnavailable() {
    messageAlert = "El documento no está disponible por ahora. Intenta de nuevo más tarde."
    showAlert = true
  }
}
