//
//  RemoteCountryRepository.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 01/10/26.
//

struct RemoteCountryRepository: CountryRepository {
  func getCountries() async throws -> [Country] {
    let response = try await APIProtocol.get(
      "/countries-states",
      as: APIResponse<[Country]>.self
    )
    return response.data
  }
}
