//
//  SuccessPage.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 19/10/26.
//

import SwiftUI

// Full screen confirmation shown after an action was saved
// (e.g. "¡Datos actualizados!" + "Continuar"), every confirmation of the app uses it
struct SuccessPage: View {
  let title: String
  let message: String
  var buttonTitle: String = "Continuar"
  let onContinue: () -> Void

  var body: some View {
    ZStack {
      Color("Background").ignoresSafeArea()

      VStack(spacing: 20) {
        Spacer()

        ZStack {
          Circle()
            .fill(Color("PrimaryAdax"))
            .frame(width: 120, height: 120)

          Image(systemName: "checkmark")
            .font(.system(size: 54, weight: .bold))
            .foregroundColor(.white)
        }

        Text(title.uppercased())
          .font(.system(size: 22, weight: .bold))
          .foregroundColor(Color("OnBackground"))
          .multilineTextAlignment(.center)

        Text(message)
          .font(.system(size: 15))
          .foregroundColor(Color("InsideTextAndIcons"))
          .multilineTextAlignment(.center)
          .padding(.horizontal, 20)

        Spacer()

        PrimaryButton(title: buttonTitle, isDisabled: false, action: onContinue)
          .padding(.bottom, 24)
      }
      .padding(.horizontal, 20)
    }
    // Only "Continuar" leaves this page, the tab bar stays visible
    .toolbar(.hidden, for: .navigationBar)
    .navigationBarBackButtonHidden(true)
  }
}

// Presents the "SuccessPage" over the whole view, the same way ".toast" is presented
extension View {
  func successScreen(
    isPresented: Binding<Bool>,
    title: String,
    message: String,
    onContinue: @escaping () -> Void = {}
  ) -> some View {
    modifier(
      SuccessScreenModifier(
        isPresented: isPresented,
        title: title,
        message: message,
        onContinue: onContinue
      )
    )
  }
}

private struct SuccessScreenModifier: ViewModifier {
  @Binding var isPresented: Bool
  let title: String
  let message: String
  let onContinue: () -> Void

  func body(content: Content) -> some View {
    content
      .overlay {
        if isPresented {
          SuccessPage(title: title, message: message) {
            isPresented = false
            onContinue()
          }
        }
      }
  }
}

#Preview {
  SuccessPage(
    title: "¡Datos actualizados!",
    message: "La información de la cuenta se actualizó correctamente",
    onContinue: {}
  )
}
