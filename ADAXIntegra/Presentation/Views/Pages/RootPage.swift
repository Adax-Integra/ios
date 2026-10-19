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
      if session.roles.contains("admin") {
        MainTabPageAdmin(userId: userId)
      } else if session.roles.contains("internal") {
        MainTabPageInterna(userId: userId)
      } else if session.roles.contains("external") {
        // V-02: external users reach the app only after accepting the privacy notice
        ConsentGatePage(
          onLogout: { Task { await session.logout() } }
        ) {
          MainTabPageExterna(userId: userId)
        }
      } else {
        // No valid role: end the session so the user goes back to the login
        ProgressView()
          .task { await session.logout() }
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
