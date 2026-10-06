//
//  Date.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 05/10/26.
//

import Foundation

/*
 This Date extension is to use to parse ISODate we received from the backend.
 How to use in entities (Add this at the end of your struct inside your entity):
 var createdDateString: String {
   createdAt.dateString
 }

 var createdTimeString: String {
   createdAt.timeString
 }

 * createdAt/updatedAt must be of type "Date"
*/

extension Date {
  /*
   Formatter to use to parse Date with timestamp w/o timezone to string.
   Invoked closure, used to configure a property with custom logic.
  */
  private static let formatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return formatter
  }()

  /*
   This is not a stored variable,
   it is a computed property that runs the code inside it
  */
  var dateString: String {
    /*
     Built in method in Foundation.
     Transforms it into the user's current config time.
     .abbreviated: From "2026/12/14" to "Dec 14, 2026"
     .omitted: Omits the time
    */
    formatted(date: .abbreviated, time: .omitted)
  }

  var timeString: String {
    /*
     Built in method in Foundation.
     Transforms it into the user's current config time.
     .omitted: Omits the date
     .shortened: "6:20:10" to "6:20 AM"
     */
    formatted(date: .omitted, time: .shortened)
  }

  // Parse ISODate to String
  static func parseISODate(_ dateISOString: String) -> Date {
    formatter.date(from: dateISOString) ?? Date()
  }

  // Extract only the date
  static func extractDate(_ isoString: String) -> String {
    parseISODate(isoString).dateString
  }

  // Extract only the time
  static func extractTime(_ isoString: String) -> String {
    parseISODate(isoString).timeString
  }
}
