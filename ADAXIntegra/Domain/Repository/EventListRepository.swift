//
//  EventListRepository.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 15/10/26.
//

import Foundation

enum EventScope {
  // Carousel with active events of the current month
  case month
  // List page it shows every active event
  case all
}

protocol EventListRepository {
  func fetchEvents(scope: EventScope) async throws -> [EventListItem]
}
