//
//  Case.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 22/09/26.
//

import Foundation
import SwiftUI

enum CaseState: String {
    case inProgress = "in_progress"
    case closed = "closed"
    case pending = "pending"

    var displayText: String {
        switch self {
        case .inProgress: return "En proceso"
        case .closed: return "Cerrado"
        case .pending: return "Pendiente"
        }
    }
    
    var indicatorColor: Color {
        switch self {
        case .inProgress: return .orange
        case .closed: return .green
        case .pending: return .red
        }
    }
}

struct Case: Identifiable, Codable {
    let id: String
    let writtenDescription: String?
    let writtenHelpsWanted: String?
    let hasLawyer: Bool
    let state: String
    let createdAt: String
    let updatedAt: String
    let helps: [String]
    let violenceTypes: [String]

    enum CodingKeys: String, CodingKey {
        case id = "caseId"
        case writtenDescription, writtenHelpsWanted, hasLawyer
        case state, createdAt, updatedAt, helps, violenceTypes
    }
}
