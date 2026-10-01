//
//  MainTabPageAdmin.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 01/10/26.
//

import SwiftUI

struct MainTabPageAdmin: View {
  @State private var selectedTab: AdminTab = .expedientes
  let userId: String

  var body: some View {
    VStack(spacing: 0) {
      Group {
        switch selectedTab {
        case .home: HomePage()
        case .expedientes: ExpedientesPage()
        case .profile: ProfilePage()
        case .admin: AdminPage()
        }
      }
      .frame(maxHeight: .infinity)

      CustomTabBarAdmin(selectedTab: $selectedTab)
    }
    .ignoresSafeArea(edges: .bottom)
  }
}
