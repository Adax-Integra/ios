//
//  UpdateCollaboratorProfileRequest.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 16/10/26.
//

import Foundation

struct UpdateCollaboratorProfileRequest: Encodable {
    let profile: ProfileChanges
    
    struct ProfileChanges: Encodable {
        let name: String?
        let lastName: String?
        let email: String?
        
        enum CodingKeys: String, CodingKey {
            case name
            case lastName = "last_name"
            case email
        }
        
        var isEmpty: Bool { name == nil && lastName == nil && email == nil }
    }
}
