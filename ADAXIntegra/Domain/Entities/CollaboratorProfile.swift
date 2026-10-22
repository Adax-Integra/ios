//
//  CollaboratorProfile.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 16/10/26.
//

import Foundation

struct CollaboratorProfile: Decodable {
    let id: String
    let name: String?
    let lastName: String?
    let email: String?
    let phone: String?
    let role: String?
    let isActive: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case name
        case lastName = "last_name"
        case email
        case phone
        case role
        case isActive = "is_active"
    }
}
