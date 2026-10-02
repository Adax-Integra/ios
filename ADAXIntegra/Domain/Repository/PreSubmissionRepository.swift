//
//  PreSubmissionRepository.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 01/10/26.
//

import Foundation

protocol PreSubmissionRepository {
  func getPreSubmission(for userId: String) async throws -> PreSubmission

  // for and with are just labels to make the parameters be read like a sentence
  func editPreSubmission(for userId: String, with preSubmission: PreSubmission) async throws
    -> PreSubmission
}
