//
//  ADAXIntegraApp.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 29/08/26.
//

import SwiftUI

@main
struct ADAXIntegraApp: App {
  @StateObject private var session = AuthSession()

  var body: some Scene {
    WindowGroup {
      RootView()
        .environmentObject(session)
    }
  }
}
