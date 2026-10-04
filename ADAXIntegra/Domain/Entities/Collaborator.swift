//
//  Collaborator.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 02/10/26.
//

import Foundation

struct NewCollaborator: Encodable {
    let name: String
    let lastName: String
    let email: String
    let password: String
    let phone: String
    
    
    enum CodingKeys: String, CodingKey {
        case name
        case lastName = "last_name"
        case email
        case password
        case phone
    }
}


struct Collaborator: Identifiable, Decodable {
    
    let id: String
    let name: String
    let lastName: String
    let email: String
    let password: String
    let phone: String
    let role: String
    
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case name
        case lastName = "last_Name"
        case email
        case password
        case phone
        case role
    }
}
