//
//  EventListItem.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 15/10/26.
//

import Foundation

// Event of GET /events (carousel and list page) for US e-01
// Separated from Event entity which is the answer of POST /events when the internal user create one
struct EventListItem: Identifiable, Decodable, Equatable {
  let id: String
  let title: String
  let description: String?
  let startsAt: String
  let endsAt: String
  let modality: String?
  let location: String?
  let imageUrl: String?
}

extension EventListItem {
  // The backend may send dates with or without fractional seconds
  private static let withFraction: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return formatter
  }()

  private static let withoutFraction: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime]
    return formatter
  }()

  private static func parseDate(_ value: String) -> Date? {
    withFraction.date(from: value) ?? withoutFraction.date(from: value)
  }

  // we stablish nil when the date cannot be read so we skip those
  var startDate: Date? { EventListItem.parseDate(startsAt) }
  var endDate: Date? { EventListItem.parseDate(endsAt) }

  var imageURL: URL? {
    imageUrl.flatMap { URL(string: $0) }
  }

  // Fixed locale: the app is in Spanish, so the badges always read "ENE" "FEB" "MAR"
  private static let displayLocale = Locale(identifier: "es_MX")

  // Day number for the date badge
  var dayString: String {
    startDate?.formatted(.dateTime.day().locale(EventListItem.displayLocale)) ?? ""
  }

  // Month for the date badge
  var monthString: String {
    startDate?.formatted(.dateTime.month(.abbreviated).locale(EventListItem.displayLocale))
      .uppercased() ?? ""
  }

  // Full date for the carousel card
  var longDateString: String {
    startDate?.formatted(
      .dateTime.day().month(.wide).year().locale(EventListItem.displayLocale)) ?? ""
  }

  // Start time in the device time zone
  var timeString: String {
    startDate?.timeString ?? ""
  }

  // Virtual events have no place so we show modality (presencial/virtual)
  var displayLocation: String? {
    if let location, !location.isEmpty { return location }
    return modality
  }
}
