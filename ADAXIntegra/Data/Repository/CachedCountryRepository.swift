//
//  CachedCountryRepository.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 01/10/26.
//

import Foundation

// We make it final class due to repository having memory, meaning it's stateful.
final class CachedCountryRepository: CountryRepository {
  // We only call the repository when nothing is cached
  private let remote: CountryRepository

  // Memory that lives while the app is running
  private var memory: [Country]?

  // Cache the JSON file in the caches directory, it survives app relaunches
  private let fileURL = FileManager.default
    .urls(for: .cachesDirectory, in: .userDomainMask)[0]
    .appendingPathComponent("countries.json")

  init(remote: CountryRepository) { self.remote = remote }

  func getCountries() async throws -> [Country] {
    // Return memory if we already have the file
    if let memory { return memory }
    /*
     Try to read and decode the saved JSON file.
     try? makes a missing or corrupted file return null instead of throwing error
    */
    if let data = try? Data(contentsOf: fileURL),
      let cached = try? JSONDecoder().decode([Country].self, from: data)
    {
      memory = cached
      return cached
    }
    // If nothing cached, download and save for next use
    let fresh = try await remote.getCountries()
    memory = fresh
    /*
     Atomic writes a temp file first,
     so if a a crash mid loading can't return a half made JSON
    */
    try? JSONEncoder().encode(fresh).write(to: fileURL, options: .atomic)
    return fresh
  }
}
