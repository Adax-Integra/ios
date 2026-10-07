//
//  VerificationCodeCard.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 06/10/26.
//

import SwiftUI

// Card with the code boxes, the resend countdown and the attempts counter
struct VerificationCodeCard: View {
  @Binding var code: String
  var errorMessage: String? = nil
  let secondsUntilResend: Int
  let attempt: Int
  var maxAttempts: Int = 3
  let onResend: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      CodeInputField(code: $code, hasError: errorMessage != nil)

      if let errorMessage {
        HelperText(text: errorMessage, isError: true)
      }

      HStack {
        // when the count down becomes 0 the resend time becomes a clickable botton
          
        if secondsUntilResend > 0 {
          Text("Reenviar código en \(formattedTime)")
            .foregroundColor(Color("IconColor"))
        } else {
          Button("Reenviar código", action: onResend)
            .fontWeight(.semibold)
            .foregroundColor(Color("PrimaryAdax"))
            .buttonStyle(.plain)
        }

        Spacer()

        Text("Intento \(attempt) de \(maxAttempts)")
          .foregroundColor(Color("IconColor"))
      }
      .font(.system(size: 14))
    }
    .padding(20)
    .background(
      RoundedRectangle(cornerRadius: 20).fill(Color("CardColor"))
    )
  }

  // Turns seconds into "m:ss", e.g. 39 -> "0:39"
  private var formattedTime: String {
    String(format: "%d:%02d", secondsUntilResend / 60, secondsUntilResend % 60)
  }
}

#Preview {
  @Previewable @State var code = ""

  VStack(spacing: 24) {
    VerificationCodeCard(
      code: $code,
      secondsUntilResend: 39,
      attempt: 1,
      onResend: { print("Reenviar") }
    )

    VerificationCodeCard(
      code: .constant("123456"),
      errorMessage: "El código es incorrecto",
      secondsUntilResend: 0,
      attempt: 2,
      onResend: { print("Reenviar") }
    )
  }
  .padding()
  .background(Color("Background"))
}
