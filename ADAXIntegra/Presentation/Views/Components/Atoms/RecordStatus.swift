//
//  RecordStatus.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 02/10/26.
//

import SwiftUI

enum RecordStatus: String, CaseIterable {
    case sinEmpezar = "SIN_EMPEZAR"
    case enRevision = "EN_REVISON"
    case enSeguimiento = "EN_SEGUIMIENTO"
    case completado = "COMPLETADO"
    
    var label: String {
        switch self {
        case .sinEmpezar: return "Sin empezar"
        case .enRevision: return "En revision"
        case .enSeguimiento: return " En seguimiento"
        case .completado: return "Completado"
        }
    }
    
    var color: Color {
        switch self {
        case .sinEmpezar: return .gray
        case .enRevision: return .orange
        case .enSeguimiento: return Color("PrimaryAdax")
        case .completado: return .green
        }
    }
    
    var allowedNext: [RecordStatus] {
        switch self {
        case .sinEmpezar: return [.enRevision]
        case .enRevision: return [.enSeguimiento]
        case .enSeguimiento: return [.completado, .enRevision]
        case .completado: return []
        }
    }
    
    func canTransition(to newStatus: RecordStatus) -> Bool {
        allowedNext.contains(newStatus)
    }
}
