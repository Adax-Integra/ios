//
//  ProfileViewModel.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 06/10/26.
//

import Combine
import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
  @Published var profile: UserProfile?
  @Published var isLoading = false
  @Published var errorMessage: String?

  private let getProfileUseCase: GetProfileUseCaseProtocol

  init(getProfileUseCase: GetProfileUseCaseProtocol? = nil) {
    self.getProfileUseCase =
      getProfileUseCase
      ?? GetProfileUseCase(dataRepository: RemoteProfileRepository())
  }

  var fullName: String {
    guard let profile else { return "" }
    return "\(profile.name) \(profile.lastName)"
  }

  var initials: String {
    guard let profile else { return "" }
    return "\(profile.name.prefix(1))\(profile.lastName.prefix(1))".uppercased()
  }

  // Same format as Android: the first 7 characters of created_at, like "2026-09"
  var memberSince: String {
    guard let profile else { return "" }
    return "Desde \(profile.createdAt.prefix(7))"
  }

  func loadProfile(for userId: String?) async {
    guard let userId else {
      errorMessage = "No hay una sesión activa."
      return
    }

    isLoading = true
    errorMessage = nil

    do {
      profile = try await getProfileUseCase.getProfile(for: userId)
    } catch {
      errorMessage = "Ocurrió un error al cargar el perfil."
    }

    isLoading = false
  }
}
