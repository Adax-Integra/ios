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

struct Case: Identifiable {
    let id: UUID
    let recordId: UUID
    let caseNumber: String?
    let description: String   // written_description
    let state: CaseState
    let createdAt: Date
    let updatedAt: Date
}
