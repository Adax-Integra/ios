//
//  Comment.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 07/10/26.
//
// Entity that tepresents the entities for case comments and author information
// Domain/Entities/Comment.swift
import Foundation

// Represents a comment  and decodes directly from the backend API
struct Comment: Identifiable, Codable {
    let id: String
    let caseId: String?
    let content: String?
    let timeSent: String?
    let author: CommentAuthor?

    enum CodingKeys: String, CodingKey {
        case id = "commentId"
        case caseId
        case content
        case timeSent
        case author
    }

    //  property to display a datewith good format
    var formattedTime: String {
        guard let timeSent = timeSent else { return "—" }
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        var date = formatter.date(from: timeSent)
        
        // Fallback without fractional seconds
        if date == nil {
            let fallbackFormatter = ISO8601DateFormatter()
            date = fallbackFormatter.date(from: timeSent)
        }
        
        guard let validDate = date else { return timeSent }
        
        let displayFormatter = DateFormatter()
        displayFormatter.locale = Locale(identifier: "es_MX")
        displayFormatter.dateFormat = "d MMM, h:mm a"
        return displayFormatter.string(from: validDate)
    }
}
// Represents the author details of a comment

struct CommentAuthor: Codable {
    let userId: String?
    let name: String?
    let lastName: String?

    var fullName: String {
        let first = name ?? ""
        let last = lastName ?? ""
        let full = "\(first) \(last)".trimmingCharacters(in: .whitespaces)
        return full.isEmpty ? "Usuario" : full
    }
}
