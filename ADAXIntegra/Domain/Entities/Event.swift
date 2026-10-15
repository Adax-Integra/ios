//
//  Event.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 15/10/26.
//
import Foundation

// Decoded directly from the get method so the
// dates stay as the String in the backend
struct Event: Identifiable, Decodable, Equatable {
  let id: String
  let title: String
  let description: String?
  let startsAt: String
  let endsAt: String
  let modality: String?
  let location: String?
  let imageUrl: String?
}

extension Event {
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

  // nil when the date cannot be read, so a wrong date is never shown
  var startDate: Date? { Event.parseDate(startsAt) }
  var endDate: Date? { Event.parseDate(endsAt) }

  var imageURL: URL? {
    imageUrl.flatMap { URL(string: $0) }
  }

  //the final users will see the app in Spanish, so the badges always read  "ENE", "FEB", "MAR"
  private static let displayLocale = Locale(identifier: "es_MX")

  // Day number for the date badge
  var dayString: String {
    startDate?.formatted(.dateTime.day().locale(Event.displayLocale)) ?? ""
  }

  // Month for the date badge, e.g. "MAR"
  var monthString: String {
    startDate?.formatted(.dateTime.month(.abbreviated).locale(Event.displayLocale))
      .uppercased() ?? ""
  }

  // Full date for the carousel card
  var longDateString: String {
    startDate?.formatted(
      .dateTime.day().month(.wide).year().locale(Event.displayLocale)) ?? ""
  }

  var timeString: String {
    startDate?.timeString ?? ""
  }

  // If a event is virutal the modality is shown instead of the location
  var displayLocation: String? {
    if let location, !location.isEmpty { return location }
    return modality
  }
}
