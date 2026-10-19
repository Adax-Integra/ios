//
//  MainTabExterna.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 22/09/26.
//

import SwiftUI

struct MainTabPageExterna: View {
  @State private var selectedTab: AppTab = .home
  @State private var contentResetCount = 0
  let userId: String

  var body: some View {
    VStack(spacing: 0) {
      Group {
        switch selectedTab {
        case .home:
          // E-01: the events title opens a list, so the home needs a NavigationStack
          NavigationStack {
            HomePageExterna(userId: userId)
              .toolbar(.hidden, for: .navigationBar)
          }
        case .cases:
          NavigationStack {
            CasesPage(
              viewModel: CasesViewModel(
                repository: RemoteCaseRepository(),
                userId: userId
              ),
              // R-02: lets CasesPage open "Nuevo caso" for this user
              userId: userId
            )
            .toolbar(.hidden, for: .navigationBar)
          }
        case .profile: ProfilePage()
        }
      }
      .id(contentResetCount)
      .frame(maxHeight: .infinity)

      CustomTabBar(
        selectedTab: $selectedTab,
        onReselect: { withAnimation { contentResetCount += 1 } }
      )
    }
    .ignoresSafeArea(edges: .bottom)
  }
}
