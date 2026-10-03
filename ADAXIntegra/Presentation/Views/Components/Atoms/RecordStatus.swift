//
//  RecordStatus.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 02/10/26.
//

import SwiftUI

enum RecordStatus: String {
    case sinEmpezar = "SIN_EMPEZAR"
    case enRevison = "EN_REVISON"
    case enSeguimiento = "EN_SEGUIMIENTO"
    case completado = "COMPLETADO"
    
    var label: String {
        switch self {
        case .sinEmpezar: return "Sin empezar"
        case .enRevison: return "En revision"
        case .enSeguimiento: return " En seguimiento"
        case .completado: return "Completado"
        }
    }
    
    var color: Color {
        switch self {
        case .sinEmpezar: return .gray
        case .enRevison: return .orange
        case .enSeguimiento: return Color("PrimaryAdax")
        case .completado: return .green
        }
    }
}
