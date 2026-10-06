//
//  ConsentGatePage.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 04/10/26.
//

import SwiftUI

// Shows the app only after the logged-in user accepted the privacy notice in force
struct ConsentGatePage<Content: View>: View {
  @StateObject private var viewModel = ConsentGateViewModel()

  let onLogout: () -> Void
  @ViewBuilder let content: () -> Content

  var body: some View {
    Group {
      if viewModel.hasAccepted == true {
        content()
      } else if viewModel.hasAccepted == false {
        PrivacyNoticePage(
          onContinue: { viewModel.markAccepted() },
          onBack: onLogout
        )
      } else {
        retryView
      }
    }
    .task { await viewModel.loadConsentStatus() }
    .alert("Algo salió mal", isPresented: $viewModel.showAlert) {
      Button("Entendido", role: .cancel) {}
    } message: {
      Text(viewModel.messageAlert)
    }
  }

  // Shown while the status is unknown: loading, or after the request failed
  private var retryView: some View {
    ZStack {
      Color("Background").ignoresSafeArea()

      if viewModel.isLoading {
        ProgressView()
      } else {
        VStack(spacing: 16) {
          Text("No pudimos verificar tu aviso de privacidad.")
            .font(.system(size: 15))
            .foregroundColor(Color("InsideTextAndIcons"))

          FormActions(
            primaryTitle: "Reintentar",
            secondaryTitle: "Cerrar sesión",
            onPrimary: { Task { await viewModel.loadConsentStatus() } },
            onSecondary: onLogout
          )
        }
        .padding(.horizontal, 24)
      }
    }
  }
}
