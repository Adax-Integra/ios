//
//  DocumentFile.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 02/10/26.
//

import Foundation

// A file the user picked to upload, kept in memory until it is sent
struct DocumentFile {
  let data: Data
  let fileName: String
  let mimeType: String

  // The backend accepts PDF, JPEG or PNG up to 5 MB
  static let maxSize = 5 * 1024 * 1024

  var isTooLarge: Bool {
    data.count > Self.maxSize
  }
}

// The two documents of the preSubmission
enum DocumentKind {
  case identity
  case proofOfAddress
}
