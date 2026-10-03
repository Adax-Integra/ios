//
//  RemoteExternalUserRepository.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 24/09/26.
//

import Foundation

struct RemoteExternalUserRepository: ExternalUserRepository {
    func register(_ request: RegisterExternalRequest) async throws -> RegisterExternalResult {
        let response = try await APIProtocol.post(
            "/internal-users/external-users",
            body: request,
            as: APIResponse<RegisterExternalResult>.self
        )
        return response.data
    }
}
