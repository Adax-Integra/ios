//
//  RootView.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 24/09/26.
//

import SwiftUI

struct RootPage: View {
  @EnvironmentObject private var session: AuthSession

  var body: some View {
    if session.isLoggedIn, let userId = session.userId {
      if session.roles.contains("internal") {
        MainTabPageInterna(userId: userId)
      } else if session.roles.contains("external") {
        // V-02: external users reach the app only after accepting the privacy notice
        ConsentGatePage(onLogout: { session.logout() }) {
          MainTabPage(userId: userId)
        }
      } else {
        MainTabPageAdmin(userId: userId)
      }
    } else {
      LoginPage(
        viewModel: LoginViewModel(
          repository: RemoteAuthRepository(),
          onLogin: { result in
            session.login(with: result)
          }
        )
      )
    }
  }
}
