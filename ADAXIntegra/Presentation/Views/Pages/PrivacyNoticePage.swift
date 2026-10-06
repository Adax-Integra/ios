//
//  PrivacyNoticePage.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 02/10/26.
//

import SwiftUI

struct PrivacyNoticePage: View {
  @StateObject private var viewModel = PrivacyNoticeViewModel()
  @State private var showExitModal = false
  @Environment(\.openURL) private var openURL

  let onContinue: () -> Void
  let onBack: () -> Void

  var body: some View {
    ZStack {
      Color("Background").ignoresSafeArea()

      ScrollView {
        VStack(alignment: .leading, spacing: 16) {
          Text("Aviso de privacidad")
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(Color("OnBackground"))

          Text("Tu información está segura con nosotras")
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(Color("PrimaryAdax"))

          Text(
            "Antes de continuar, es importante que conozcas cómo usamos y protegemos tus datos personales."
          )
          .font(.system(size: 15))
          .foregroundColor(Color("InsideTextAndIcons"))

          PrivacyNoticeSummary()

          SurfaceCard {
            ConsentCheckboxRow(
              isChecked: $viewModel.hasAccepted,
              onNoticeTapped: {
                if let link = viewModel.policy?.documentUrl, let url = URL(string: link) {
                  openURL(url)
                } else {
                  viewModel.showDocumentUnavailable()
                }
              }
            )
            .padding(16)
          }

          FormActions(
            primaryTitle: "Continuar",
            secondaryTitle: "No continuar",
            isPrimaryDisabled: !viewModel.canContinue,
            onPrimary: {
              Task {
                if await viewModel.registerConsent() {
                  onContinue()
                }
              }
            },
            onSecondary: { showExitModal = true }
          )
          .padding(.top, 8)
          .padding(.bottom, 24)
        }
        .padding(.horizontal, 20)
      }

      if showExitModal {
        exitModal
      }
    }
    .task { await viewModel.loadCurrentPolicy() }
    .overlay {
      if viewModel.isLoading {
        Color.black.opacity(0.15)
          .ignoresSafeArea()
          .overlay { ProgressView() }
      }
    }
    .alert("Algo salió mal", isPresented: $viewModel.showAlert) {
      Button("Entendido", role: .cancel) {}
    } message: {
      Text(viewModel.messageAlert)
    }
  }

  private var exitModal: some View {
    ZStack {
      Color.black.opacity(0.4)
        .ignoresSafeArea()
        .onTapGesture { showExitModal = false }

      SurfaceCard {
        VStack(alignment: .leading, spacing: 12) {
          Text("¿Prefieres no continuar?")
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(Color("OnBackground"))

          Text(
            "Para poder acompañarte necesitamos tu consentimiento, sin él no podemos dar seguimiento a tu caso."
          )
          .font(.system(size: 15))
          .foregroundColor(Color("InsideTextAndIcons"))

          Text(
            "Si sales ahora se cerrará tu sesión. Podrás aceptar el aviso la próxima vez que entres."
          )
          .font(.system(size: 15))
          .foregroundColor(Color("InsideTextAndIcons"))

          FormActions(
            primaryTitle: "Volver al aviso",
            secondaryTitle: "Salir",
            onPrimary: { showExitModal = false },
            onSecondary: onBack
          )
          .padding(.top, 8)
        }
        .padding(24)
      }
      .padding(.horizontal, 24)
    }
  }
}

#Preview {
  PrivacyNoticePage(onContinue: {}, onBack: {})
}
