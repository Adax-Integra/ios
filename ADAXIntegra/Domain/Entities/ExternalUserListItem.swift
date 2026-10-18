//
//  ExternalUserListItem.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 16/10/26.
//

import Foundation

// G-16: one page of GET /internal-users/external-users
struct ExternalUserListResult: Decodable {
  let users: [ExternalUserListItem]
  let total: Int
  let page: Int
  let limit: Int
}

// G-16: one external account of the list
struct ExternalUserListItem: Identifiable, Decodable {
  let id: String
  let name: String?
  let lastName: String?
  let email: String?
  let createdAt: String?
  let isActive: Bool

  enum CodingKeys: String, CodingKey {
    case id = "user_id"
    case name
    case lastName = "last_name"
    case email
    case createdAt = "created_at"
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

  // Only the date is shown. The first 19 characters are read so it
  // works with or without milliseconds, the same as RecordListItem
  var createdDateText: String {
    guard let createdAt, createdAt.count >= 19 else { return "Sin fecha" }

    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(identifier: "UTC")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

    guard let date = formatter.date(from: String(createdAt.prefix(19))) else {
      return "Sin fecha"
    }
    return date.dateString
  }
}
