//
//  EventRepository.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 15/10/26.
//

import Foundation

enum EventScope {
  // Carrousel of  active events of the current month
  case month
  case all
}

protocol EventRepository {
  func fetchEvents(scope: EventScope) async throws -> [Event]
}
