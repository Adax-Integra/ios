//
//  CaseListItem.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 24/09/26.
//
import Foundation

struct CaseListResult : Decodable {
    
    let cases : [CaseListItem]
    let total : Int
    let page : Int
    let limit: Int
    
}

struct CaseListItem: Identifiable, Decodable {
    let id : String
    let name : String
    let violenceTypes : [String]
    let state : String
    let urgency : String
    let updatedAt : String?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "case_id"
        case name
        case violenceTypes = "violence_types"
        case state
        case urgency
        case updatedAt = "updated_at"
    }
}

extension CaseListItem {
    var displayName: String {
        name.isEmpty ? "Sin nombre" : name
    }
    
    var stateText: String {
        switch state {
        case "Open": return "En proceso"
        case "Closed": return "Completado"
        default: return state
        }
    }

    var updatedDate: Date? {
        guard let updatedAt, updatedAt.count >= 19 else { return nil }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter.date(from: String(updatedAt.prefix(19)))
        
    }
}


