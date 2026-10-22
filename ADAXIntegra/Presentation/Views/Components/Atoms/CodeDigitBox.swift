//
//  CodeDigitBox.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 06/10/26.
//



import SwiftUI

// Single box of the verification code to verifay autenticación on the person


struct CodeDigitBox: View {
  let digit: String
  var isFocused: Bool = false
  var hasError: Bool = false

  private var borderColor: Color {
    if hasError { return Color("Error") }
    return isFocused ? Color("PrimaryAdax") : Color.gray.opacity(0.35)
  }

  var body: some View {
    Text(digit)
      .font(.system(size: 24, weight: .semibold))
      .foregroundColor(.black)
      .frame(maxWidth: .infinity)
      .frame(height: 56)
      .background(
        RoundedRectangle(cornerRadius: 12).fill(Color.white)
      )
      .overlay(
        RoundedRectangle(cornerRadius: 12)
          .stroke(borderColor, lineWidth: isFocused || hasError ? 2 : 1)
      )
  }
}

#Preview {
  HStack(spacing: 10) {
    CodeDigitBox(digit: "4")
    CodeDigitBox(digit: "7")
    CodeDigitBox(digit: "", isFocused: true)
    CodeDigitBox(digit: "")
    CodeDigitBox(digit: "")
    CodeDigitBox(digit: "", hasError: true)
  }
  .padding()
  .background(Color("Background"))
}
