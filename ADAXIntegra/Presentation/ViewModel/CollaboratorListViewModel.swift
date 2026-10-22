//
//  CollaboratorListViewModel.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 10/10/26.
//

import Combine
import Foundation

// G-06: loads the list shown in "Gestión de Colaboradoras"
@MainActor
final class CollaboratorListViewModel: ObservableObject {
  @Published private(set) var collaborators: [CollaboratorListItem] = []
  @Published private(set) var isLoading = false
  @Published private(set) var errorMessage: String?

  private let listCollaboratorsUseCase: ListCollaboratorsUseCaseProtocol

  init(listCollaboratorsUseCase: ListCollaboratorsUseCaseProtocol? = nil) {
    // Built here so it runs on the main actor, same as the other ViewModels
    self.listCollaboratorsUseCase =
      listCollaboratorsUseCase
      ?? ListCollaboratorsUseCase(dataRepository: RemoteCollaboratorRepository())
  }

  var countText: String {
    collaborators.count == 1 ? "1 cuenta" : "\(collaborators.count) cuentas"
  }

  // The backend already sends the newest first, so the order is kept as is
  func load() async {
    isLoading = true
    errorMessage = nil

    do {
      collaborators = try await listCollaboratorsUseCase.listCollaborators()
    } catch {
      errorMessage = "Revisa tu conexión e intenta de nuevo."
    }
    isLoading = false
  }
}
