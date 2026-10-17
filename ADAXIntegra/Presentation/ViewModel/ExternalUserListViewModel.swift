//
//  ExternalUserListViewModel.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 16/10/26.
//

import Combine
import Foundation

// G-16: loads the list shown in "Cuentas de externas"
@MainActor
final class ExternalUserListViewModel: ObservableObject {
  @Published var users: [ExternalUserListItem] = []
  @Published var total = 0
  @Published var isLoading = false
  @Published var errorMessage: String?

  //Same default values as the backend: active accounts, newest first
  @Published var searchText = ""
  @Published var statusFilter = "active"
  @Published var sortOption = "recent"

  private var currentPage = 1
  private let listExternalUsersUseCase: ListExternalUsersUseCaseProtocol

  init(listExternalUsersUseCase: ListExternalUsersUseCaseProtocol? = nil) {
    // Built here so it runs on the main actor, same as other ViewModels
    self.listExternalUsersUseCase =
      listExternalUsersUseCase
      ?? ListExternalUsersUseCase(dataRepository: RemoteExternalUserListRepository())
  }

  // The backend sends 10 accounts per page
  var canLoadMore: Bool {
    users.count < total
  }

  var countText: String {
    total == 1 ? "1 cuenta" : "\(total) cuentas"
  }

  // Starts again from the first page, used when the screen appears or a filter changes
  func loadFirstPage() async {
    currentPage = 1
    users = []
    await loadPage()
  }

  // "Ver más" adds the next 10 accounts at the end of the list
  func loadNextPage() async {
    currentPage += 1
    await loadPage()
  }

  private func loadPage() async {
    isLoading = true
    errorMessage = nil

    // The search can change while the answer arrives, so it is saved before asking
    let searchedText = searchText

    do {
      let result = try await listExternalUsersUseCase.listExternalUsers(
        page: currentPage,
        search: searchedText.trimmingCharacters(in: .whitespacesAndNewlines),
        status: statusFilter,
        sort: sortOption
      )

      // A newer search already started, so this old answer is ignored
      guard searchedText == searchText else {
        isLoading = false
        return
      }

      if currentPage == 1 {
        users = result.users
      } else {
        users.append(contentsOf: result.users)
      }
      total = result.total
    } catch {
      errorMessage = "Revisa tu conexión e intenta de nuevo."
      // The same page is asked again the next time
      if currentPage > 1 {
        currentPage -= 1
      }
    }
    isLoading = false
  }
}
