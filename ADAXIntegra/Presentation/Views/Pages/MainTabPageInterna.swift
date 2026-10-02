//
//  MainTabPageInterna.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 29/09/26.
//

import SwiftUI

struct MainTabPageInterna: View {
  @State private var selectedTab: InternaTab = .expedientes
  let userId: String

  var body: some View {
    VStack(spacing: 0) {
      Group {
        switch selectedTab {
        case .home: HomePage()
        case .expedientes: ExpedientesPage()
        case .profile: ProfilePage()
        }
      }
      .frame(maxHeight: .infinity)

      CustomTabBarInterna(selectedTab: $selectedTab)
    }
    .ignoresSafeArea(edges: .bottom)
  }
}
