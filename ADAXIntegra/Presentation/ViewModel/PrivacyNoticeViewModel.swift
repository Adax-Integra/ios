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
  private let registerConsentUseCase: RegisterConsentUseCaseProtocol

  init(
    getCurrentPolicyUseCase: GetCurrentPolicyUseCaseProtocol? = nil,
    registerConsentUseCase: RegisterConsentUseCaseProtocol? = nil
  ) {
    self.getCurrentPolicyUseCase =
      getCurrentPolicyUseCase
      ?? GetCurrentPolicyUseCase(dataRepository: RemotePrivacyPolicyRepository())
    self.registerConsentUseCase =
      registerConsentUseCase
      ?? RegisterConsentUseCase(dataRepository: RemotePrivacyPolicyRepository())
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

  // Returns true only when the backend stored the consent, so the page moves on
  // only after it is actually registered
  func registerConsent() async -> Bool {
    guard let policy, hasAccepted else { return false }
    isLoading = true

    do {
      _ = try await registerConsentUseCase.registerConsent(policyId: policy.policyId)
      isLoading = false
      return true
    } catch {
      messageAlert =
        "No pudimos registrar tu consentimiento. Revisa tu conexión e intenta de nuevo."
      showAlert = true
      isLoading = false
      return false
    }
  }

  func showDocumentUnavailable() {
    messageAlert = "El documento no está disponible por ahora. Intenta de nuevo más tarde."
    showAlert = true
  }
}
