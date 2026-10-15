//
//  Event.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 15/10/26.
//

import Foundation

// Data an internal user captures to create an event
struct NewEvent: Encodable {
  let title: String
  let startsAt: String
  let endsAt: String
  let modality: String
  let location: String?
  let link: String?
  let phone: String?
  let description: String
  let notes: String?
}

// Event returned by POST /events
struct Event: Decodable {
  let eventId: String
  let title: String?
  let startsAt: String?
  let endsAt: String?
  let modality: String?
  let location: String?
  let link: String?
  let phone: String?
  let description: String?
  let notes: String?
}

// Answer of PATCH /events/:eventId/image
struct EventImage: Decodable {
  let eventId: String?
  let imageUrl: String?
}
