//
//  RootView.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 24/09/26.
//

import SwiftUI

struct RootView: View {
  @EnvironmentObject private var session: AuthSession

  var body: some View {
    if session.isLoggedIn, let userId = session.userId {
      MainTabView(userId: userId)
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
