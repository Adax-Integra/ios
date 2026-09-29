//
//  CaseRepositoryP.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 23/09/26.
//

import Foundation

// Contract for creating a case. Domain only knows this protocol.
// Data provides the implementation (RemoteCreateCaseRepository)
// Returns the id of the created case, or nil if the request failed
protocol CaseRepositoryP {
  func createCase(_ newCase: CaseEntity, userId: String) async -> String?
}
