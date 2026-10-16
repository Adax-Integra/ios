//
//  DisabledEvent.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 14/10/26.
//

import Foundation

// E-03: response of PATCH /events/:eventId/disable
struct DisabledEvent: Decodable {
  let eventId: String
  let disabledAt: String
}
