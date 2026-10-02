//
//  APIErrorResponse.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 02/10/26.
//

import Foundation

//error body returned by backend
// success : false -> error : ""
// success : false -> errors : "field : reason"


struct APIErrorResponse: Decodable {
    let success: Bool
    let error: String?
    let errors: [String: String]?
}
