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
  var notes: String? = nil
  var link: String? = nil
  var phone: String? = nil
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

  // the app is in Spanish, so the badges always read "ENE" "FEB" "MAR"
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

  // Detail screen

  private static let detailDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = EventListItem.displayLocale
    formatter.dateFormat = "EEEE d 'de' MMMM, yyyy"
    return formatter
  }()

  private static let hourFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "h:mm"
    return formatter
  }()

  private static let periodFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "a"
    return formatter
  }()

  var detailDateString: String {
    guard let startDate else { return "" }
    let text = EventListItem.detailDateFormatter.string(from: startDate)
    return text.prefix(1).uppercased() + text.dropFirst()
  }

  var timeRangeString: String {
    guard let startDate else { return "" }
    let start = EventListItem.hourFormatter.string(from: startDate)
    let startPeriod = EventListItem.periodFormatter.string(from: startDate)

    guard let endDate else { return "\(start) \(startPeriod)" }
    let end = EventListItem.hourFormatter.string(from: endDate)
    let endPeriod = EventListItem.periodFormatter.string(from: endDate)

    if startPeriod == endPeriod {
      return "\(start)-\(end) \(endPeriod)"
    }
    return "\(start) \(startPeriod) - \(end) \(endPeriod)"
  }

  var detailPlaceString: String? {
    let place = (location?.isEmpty == false) ? location : nil
    let mode = (modality?.isEmpty == false) ? modality?.lowercased() : nil

    switch (place, mode) {
    case let (place?, mode?): return "\(place) (\(mode))"
    case let (place?, nil): return place
    case let (nil, mode?): return mode.capitalized
    default: return nil
    }
  }

  // nil when the event has no notes, so the section is not shown
  var displayNotes: String? {
    guard let notes,
      !notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    else { return nil }
    return notes
  }
}
