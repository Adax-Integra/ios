//
//  DateOfBirth.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 06/10/26.
//

import Foundation

/*
 This Date extension is to use to parse Date (w/o time or timezone) we received from the backend.
 How to use in entities (Add this at the end of your struct inside your entity):
*/
extension Date {
  /*
   Formatter to use to parse Date w/o time or timezone to string.
   Invoked closure, used to configure a property with custom logic.
  */
  private static let birthDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    // Make the format the same for every user or phone regardless of region
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()

  static func parseBirthDate(_ string: String) -> Date? {
    birthDateFormatter.date(from: string)
  }

  var birthDateString: String {
    Self.birthDateFormatter.string(from: self)
  }
}
