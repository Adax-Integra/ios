//
//  MainTabPageInterna.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 29/09/26.
//

import SwiftUI

struct MainTabPageInterna: View {
  @State private var selectedTab: AppTab = .cases
  let userId: String

  var body: some View {
    VStack(spacing: 0) {
      Group {
        switch selectedTab {
        case .home: HomePage()
        case .cases:
          ExpedientesPageInterna()
          )
        case .profile: ProfilePage()
        }
      }
      .frame(maxHeight: .infinity)

      CustomTabBar(selectedTab: $selectedTab)
    }
    .ignoresSafeArea(edges: .bottom)
  }
}
