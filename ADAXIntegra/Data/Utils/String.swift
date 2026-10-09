//
//  String.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 08/10/26.
//

import Foundation

/*
 This String extension is to use for formatting names we receive from the backend.
 How to use:
 "Ana López".firstName // "Ana"
*/

extension String {
  // Returns the first word of a full name, or the whole string if it has no spaces
  var firstName: String {
    split(separator: " ").first.map(String.init) ?? self
  }
}
