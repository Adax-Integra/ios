//
//  CaseRepository.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 22/09/26.
//
import Foundation

protocol CaseRepository {
    func getCases(for userId: String) async throws -> [Case]
}
