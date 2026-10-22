//
//  ExternalUserListRepository.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 16/10/26.
//

import Foundation

protocol ExternalUserListRepository {
  // G-16: external accounts, 10 per page
  func listExternalUsers(
    page: Int,
    search: String,
    status: String,
    sort: String
  ) async throws -> ExternalUserListResult
}
