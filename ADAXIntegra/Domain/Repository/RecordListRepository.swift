//
//  RecordListRepository.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 02/10/26.
//

import Foundation


protocol RecordListRepository {
    func listRecords(page: Int,
                    search: String,
                    hasOpenCases: Bool?,
                    status: String?) async throws -> RecordListResult
}
