//
//  ConsentGateViewModel.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 04/10/26.
//

import Combine
import Foundation

@MainActor
final class ConsentGateViewModel: ObservableObject {
  // Nil until the backend answers: the app stays closed while the status is unknown
  @Published var hasAccepted: Bool?
  @Published var isLoading = false
  @Published var showAlert = false
  @Published var messageAlert = ""

  private let getConsentStatusUseCase: GetConsentStatusUseCaseProtocol

  init(getConsentStatusUseCase: GetConsentStatusUseCaseProtocol? = nil) {
    self.getConsentStatusUseCase =
      getConsentStatusUseCase
      ?? GetConsentStatusUseCase(dataRepository: RemotePrivacyPolicyRepository())
  }

  func loadConsentStatus() async {
    isLoading = true

    do {
      hasAccepted = try await getConsentStatusUseCase.getConsentStatus().hasAccepted
    } catch {
      messageAlert =
        "No pudimos verificar tu aviso de privacidad. Revisa tu conexión e intenta de nuevo."
      showAlert = true
    }

    isLoading = false
  }

  func markAccepted() {
    hasAccepted = true
  }
}
