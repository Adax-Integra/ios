//
//  ExternalUserRepository.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 24/09/26.
//

import Foundation

protocol ExternalUserRepository {
    func register(_ request: RegisterExternalRequest) async throws -> RegisterExternalResult
}
