//
//  CountryRepository.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 01/10/26.
//

protocol CountryRepository {
  func getCountries() async throws -> [Country]
}
