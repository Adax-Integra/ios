//
//  CaseRepository.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 22/09/26.
//
import Foundation

protocol CaseRepository {
  func getCases(for userId: String) async throws -> [Case]

  // R-02: returns the id of the created case, or nil if the request failed
  func createCase(_ newCase: NewCase, userId: String) async -> String?
}
