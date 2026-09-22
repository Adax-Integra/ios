//
//  MockCaseRepository.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 22/09/26.
//

import Foundation

final class MockCaseRepository: CaseRepository {
    func getCases(for userId: UUID) async throws -> [Case] {
        [
            Case(id: UUID(), recordId: UUID(), caseNumber: "2026-089",
                 description: "Violencia Familiar y Económica", state: .inProgress,
                 createdAt: Date().addingTimeInterval(-3600 * 24 * 5),
                 updatedAt: Date().addingTimeInterval(-3600 * 2)),
            Case(id: UUID(), recordId: UUID(), caseNumber: "2026-085",
                 description: "Violencia Psicológica", state: .inProgress,
                 createdAt: Date().addingTimeInterval(-3600 * 24 * 160),
                 updatedAt: Date().addingTimeInterval(-3600 * 24 * 60)),
            Case(id: UUID(), recordId: UUID(), caseNumber: "2026-078",
                 description: "Seguimiento Jurídico", state: .inProgress,
                 createdAt: Date().addingTimeInterval(-3600 * 24 * 250),
                 updatedAt: Date().addingTimeInterval(-3600 * 24 * 90))
        ]
    }
}
