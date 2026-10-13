//
//  CollaboratorListItem.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 09/10/26.
//

import Foundation

// G-06: one collaborator of GET /internal-users
struct CollaboratorListItem: Identifiable, Codable {
  let id: String
  let name: String?
  let lastName: String?
  let email: String?
  let role: String?
  let isActive: Bool

  enum CodingKeys: String, CodingKey {
    case id = "user_id"
    case name
    case lastName = "last_name"
    case email
    case role
    case isActive = "is_active"
  }

  var fullName: String {
    let text = "\(name ?? "") \(lastName ?? "")".trimmingCharacters(in: .whitespaces)
    return text.isEmpty ? "Sin nombre" : text
  }

  var initials: String {
    let first = name?.first.map(String.init) ?? ""
    let second = lastName?.first.map(String.init) ?? ""
    return (first + second).uppercased()
  }

}
