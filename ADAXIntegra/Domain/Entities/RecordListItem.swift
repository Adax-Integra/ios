//
//  RecordListItem.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 02/10/26.
//

import Foundation

struct RecordListResult: Decodable {
    let records: [RecordListItem]
    let total: Int
    let page: Int
    let limit: Int
}

struct RecordListItem: Identifiable, Decodable {
    let id: String
    let userId: String
    let name: String
    let recordNumber: String?
    let status: String?
    let activeCasesCount: Int
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "record_id"
        case userId = "user_id"
        case name
        case recordNumber = "record_number"
        case status
        case activeCasesCount = "active_cases_count"
        case updatedAt = "updated_at"
    }
}

extension RecordListItem {
    var displayName: String {
        name.isEmpty ? "Sin nombre" : name
    }
    
    var displayFolio: String {
        recordNumber ?? "Sin folio"
    }
    
    var hasOpenCases: Bool {
        activeCasesCount > 0
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

