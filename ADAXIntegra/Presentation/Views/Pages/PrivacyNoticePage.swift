//
//  PrivacyNoticePage.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 02/10/26.
//

import SwiftUI

struct PrivacyNoticePage: View {
  // Starts unchecked: consent must be given by the user, never preselected
  @State private var hasAccepted = false
  @State private var showExitModal = false

  let onContinue: () -> Void
  let onBack: () -> Void

  var body: some View {
    ZStack {
      Color("Background").ignoresSafeArea()

      ScrollView {
        VStack(alignment: .leading, spacing: 16) {
          PageHeader(title: "Aviso de privacidad", backAction: onBack)

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
            ConsentCheckboxRow(isChecked: $hasAccepted, onNoticeTapped: {})
              .padding(16)
          }

          FormActions(
            primaryTitle: "Continuar",
            secondaryTitle: "No continuar",
            isPrimaryDisabled: !hasAccepted,
            onPrimary: onContinue,
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
            "Para poder acompañarte necesitamos tu consentimiento, sin él no podemos crear tu expediente ni dar seguimiento a tu caso."
          )
          .font(.system(size: 15))
          .foregroundColor(Color("InsideTextAndIcons"))

          Text(
            "Si sales ahora no se guarda ningún dato tuyo y puedes volver a intentarlo cuando quieras."
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
