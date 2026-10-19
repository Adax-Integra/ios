//
//  ActivityLogItem.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 18/10/26.


import Foundation

// Wrapper of the "data" field returned by GET /internal-users/activity-log
struct ActivityLogResult: Decodable {
  let logs: [ActivityLogItem]
  let total: Int
  let page: Int
  let limit: Int
}

// for V-06 one entry of the activity log where the backend already sends the actor name
// the target and a readable sentence
struct ActivityLogItem: Identifiable, Decodable {
  let id: String
  let actorName: String
  let action: String
  let actionLabel: String
  let entity: String?
  let entityId: String?
  let target: String
  let description: String
  let reason: String
  let createdAt: String

  // Maps the snake_case keys of the backend to camelCase properties
  enum CodingKeys: String, CodingKey {
    case id = "log_id"
    case actorName = "actor_name"
    case action
    case actionLabel = "action_label"
    case entity
    case entityId = "entity_id"
    case target
    case description
    case reason
    case createdAt = "created_at"
  }
}

extension ActivityLogItem {
  // Parses the ISO date sent by the backend using the Date utils
  var date: Date { Date.parseISODate(createdAt) }

  // Date and time already formatted for the user's device settings
  var dateString: String { date.dateString }
  var timeString: String { date.timeString }

  // SF Symbol shown for each action. Unknown actions get a generic icon
  var iconName: String {
    let key = action.lowercased()
    if key == "update_external_profile" { return "pencil" }
    if key.contains("reactivate") { return "person.crop.circle.badge.checkmark" }
    if key.contains("deactivate") { return "person.crop.circle.badge.xmark" }
    return "clock.arrow.circlepath"
  }
}

