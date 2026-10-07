//
//  ProfileRepository.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 06/10/26.
//

import Foundation

protocol ProfileRepository {
  func getProfile(for userId: String) async throws -> UserProfile
}
