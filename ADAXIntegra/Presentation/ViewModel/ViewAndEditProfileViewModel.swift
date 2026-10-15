//
//  ViewAndEditProfileViewModel.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 15/10/26.
//

import Combine
import Foundation

// R-04: the logged-in user views and edits their own profile
@MainActor
final class ViewAndEditProfileViewModel: ObservableObject {
  struct Form {
    var name = ""
    var lastName = ""
    var countryCode: String?
    var phone = ""
    var country: String?
    var state: String?
    var municipality = ""
  }

  @Published var form = Form()
  @Published private(set) var countries: [Country] = []
  @Published var isLoading = false
  @Published var isSaving = false
  @Published var isEditing = false
  @Published var errorMessage: String?

  // Only external users have an address
  let showsAddress: Bool

  // Loaded values, used to undo the changes when editing is cancelled
  private var saved = Form()
  private let userId: String?
  private let useCase: ViewAndEditProfileUseCaseProtocol
  private let countryRepository: CountryRepository

  init(userId: String?, roles: [String]) {
    self.userId = userId
    self.showsAddress = roles == ["external"]
    self.useCase = ViewAndEditProfileUseCase(
      dataRepository: RemoteViewAndEditProfileRepository())
    self.countryRepository = CachedCountryRepository(remote: RemoteCountryRepository())
  }

  var countryCodes: [String] { Country.dialCodes(in: countries) }
  var countryOptions: [String] { countries.map(\.nameEs) }
  var stateOptions: [String] {
    Country.first(name: form.country ?? "", in: countries)?.stateNames ?? []
  }

  func load() async {
    guard let userId else { return }
    isLoading = true
    countries = (try? await countryRepository.getCountries()) ?? []

    do {
      try await fetchProfile(for: userId)
    } catch {
      errorMessage = "Ocurrió un error al cargar el perfil."
    }
    isLoading = false
  }

  func startEditing() {
    isEditing = true
  }

  func cancelEditing() {
    form = saved
    isEditing = false
  }

  func save() async {
    guard let userId else { return }
    isSaving = true

    var request = UpdateProfileRequest(
      name: form.name,
      lastName: form.lastName,
      phone: (form.countryCode ?? "") + form.phone
    )
    if showsAddress {
      request.country = form.country
      request.state = form.state
      request.municipality = form.municipality.isEmpty ? nil : form.municipality
    }

    do {
      try await useCase.editProfile(for: userId, with: request)
      // PATCH only answers with a message, so the profile is loaded again
      try await fetchProfile(for: userId)
      isEditing = false
    } catch {
      errorMessage = "No pudimos guardar los cambios. Revisa los datos e intenta de nuevo."
    }
    isSaving = false
  }

  private func fetchProfile(for userId: String) async throws {
    var data = Form()

    if showsAddress {
      let profile = try await useCase.getExternalProfile(for: userId)
      data.name = profile.name
      data.lastName = profile.lastName
      data.phone = profile.phone
      data.country = profile.address?.country
      data.state = profile.address?.state
      data.municipality = profile.address?.municipality ?? ""
    } else {
      let profile = try await useCase.getStaffProfile(for: userId)
      data.name = profile.name
      data.lastName = profile.lastName
      data.phone = profile.phone
    }

    if data.phone.count > 10 {
      data.countryCode = String(data.phone.dropLast(10))
      data.phone = String(data.phone.suffix(10))
    }

    saved = data
    form = data
  }
}
