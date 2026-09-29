//
//  CaseListRepository.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 24/09/26.
//

import Foundation

protocol CaseListRepository {
    func listCases(page: Int,
                  limit: Int,
                  search: String,
                  urgency: String) async throws -> CaseListResult
}
