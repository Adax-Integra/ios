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
        let addressLine1: String
        let addressLine2: String?
        let neighborhood: String
        let zipCode: String
        let country: String
        let state: String
        let city: String
        
        enum CodingKeys: String, CodingKey {
            case addressLine1 = "address_line_1"
            case addressLine2 = "address_line_2"
            case neighborhood
            case zipCode = "zip_code"
            case country
            case state
            case city
        }
    }
}

struct RegisterExternalResult: Decodable {
    let userId: String
    let recordId: String
    let addressId: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case recordId = "record_id"
        case addressId = "address_id"
    }
}
