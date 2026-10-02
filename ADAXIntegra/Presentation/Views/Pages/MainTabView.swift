//
//  MainTabView.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 22/09/26.
//

import SwiftUI

struct MainTabView: View {
  @State private var selectedTab: AppTab = .cases
  let userId: String

  var body: some View {
    VStack(spacing: 0) {
      Group {
        switch selectedTab {
        case .home: HomePage()
        case .cases:
          CasesPage(
            viewModel: CasesViewModel(
              repository: RemoteCaseRepository(),
              userId: userId
            ),
            // R-02: lets CasesPage open "Nuevo caso" for this user
            userId: userId
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
