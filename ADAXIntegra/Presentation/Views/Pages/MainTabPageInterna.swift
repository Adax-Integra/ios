//
//  MainTabPageInterna.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 29/09/26.
//

import SwiftUI

struct MainTabPageInterna: View {
  @State private var selectedTab: InternaTab = .home
  @State private var contentResetCount = 0
  let userId: String

  var body: some View {
    VStack(spacing: 0) {
      Group {
        switch selectedTab {
        case .home: NavigationStack { HomePage() }
        case .expedientes: NavigationStack { ExpedientesPage() }
        case .profile: ProfilePage()
        }
      }
      .id(contentResetCount)
      .frame(maxHeight: .infinity)

      CustomTabBarInterna(
        selectedTab: $selectedTab,
        onReselect: { withAnimation { contentResetCount += 1 } }
      )
    }
    .ignoresSafeArea(edges: .bottom)
  }
}
