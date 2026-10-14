//
//  RegisterExternalDTO.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 24/09/26.
//

import Foundation

struct RegisterExternalRequest: Encodable {
    let profile: Profile
    let address: Address
    
    struct Profile: Encodable {
        let name: String
        let lastName: String
        let email: String
        let birthDate: String?
        let phone: String?
        
        enum CodingKeys: String, CodingKey {
            case name
            case lastName = "last_name"
            case email
            case birthDate = "birth_date"
            case phone
        }
    }
    
    struct Address: Encodable {
        let country: String
        let state: String
        let municipality: String
    }
}

struct RegisterExternalResult: Decodable {
    let userId: String
    let recordId: String
    let recordNumber: String?
    let addressId: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case recordId = "record_id"
        case recordNumber = "record_number"
        case addressId = "address_id"
    }
}
