//
//  PreSubmissionRepository.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 01/10/26.
//

import Foundation

protocol PreSubmissionRepository {
  func getPreSubmission(for userId: String) async throws -> PreSubmission
}
