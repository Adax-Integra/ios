//
//  MainTabPageAdmin.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 01/10/26.
//

import SwiftUI

struct MainTabPageAdmin: View {
  @State private var selectedTab: AdminTab = .home
  @State private var contentResetCount = 0
  let userId: String

  var body: some View {
    VStack(spacing: 0) {
      Group {
        switch selectedTab {
        case .home: NavigationStack { HomePage() }
        case .expedientes: NavigationStack { ExpedientesPage() }
        case .profile: ProfilePage()
        case .admin: AdminPage()
        }
      }
      .id(contentResetCount)
      .frame(maxHeight: .infinity)

      CustomTabBarAdmin(
        selectedTab: $selectedTab,
        onReselect: { withAnimation { contentResetCount += 1 } }
      )
    }
    .ignoresSafeArea(edges: .bottom)
  }
}
