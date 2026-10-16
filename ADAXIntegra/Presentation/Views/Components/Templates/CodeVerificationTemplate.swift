//
//  CodeVerificationTemplate.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 14/10/26.
//

import SwiftUI

struct CodeVerificationTemplate: View {
  let description: String
  let maskedEmail: String
  @Binding var code: String
  var errorMessage: String? = nil
  let secondsUntilResend: Int
  let attempt: Int
  var maxAttempts: Int = 5
  var canResend: Bool = true
  // G-05 resends directly -> G-09 opens a sheet so the link can be enabled independently
  var isResendLinkEnabled: Bool = true
  var isVerifyDisabled: Bool = false
  var verifyTitle: String = "Verificar"
  let backAction: () -> Void
  let onResendTapped: () -> Void
  let onVerify: () -> Void

  var body: some View {
    ZStack {
      Color("Background").ignoresSafeArea()

      VStack(alignment: .leading, spacing: 20) {
        PageHeader(title: "Verifica tu cuenta", backAction: backAction)

        VStack(alignment: .leading, spacing: 6) {
          Text(description)
            .font(.system(size: 15))
            .foregroundColor(Color("OnBackgroundColor"))
            .lineSpacing(3)

          Text("Si no lo ves, revisa tu carpeta de spam.")
            .font(.system(size: 13))
            .foregroundColor(Color("IconColor"))
        }
        .fixedSize(horizontal: false, vertical: true)

        CodeSentCard(email: maskedEmail)

        VerificationCodeCard(
          code: $code,
          errorMessage: errorMessage,
          secondsUntilResend: secondsUntilResend,
          attempt: attempt,
          maxAttempts: maxAttempts,
          canResend: canResend
        )

        Button(action: onResendTapped) {
          Text("¿No recibiste el código?")
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(isResendLinkEnabled ? Color("PrimaryAdax") : Color("IconColor"))
            .underline(isResendLinkEnabled)
        }
        .buttonStyle(.plain)
        .disabled(!isResendLinkEnabled)
        .frame(maxWidth: .infinity)

        Spacer()

        PrimaryButton(title: verifyTitle, isDisabled: isVerifyDisabled, action: onVerify)
      }
      .padding()
    }
    // Closes the keyboard when tapping outside the code boxes
    .onTapGesture {
      UIApplication.shared.sendAction(
        #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil
      )
    }
  }
}

#Preview {
  @Previewable @State var code = ""

  CodeVerificationTemplate(
    description:
      "Enviamos un código de 6 dígitos a tu correo. Ingrésalo para completar tu registro.",
    maskedEmail: "d••••••••@gmail.com",
    code: $code,
    secondsUntilResend: 39,
    attempt: 1,
    backAction: {},
    onResendTapped: {},
    onVerify: {}
  )
}
