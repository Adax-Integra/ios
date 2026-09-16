//
//  TextField.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 16/09/26.
//

import SwiftUI

struct CustomTextField: View {
  let placeholder: String
  @Binding var text: String
  // Keyboard layout for this field (email, number, default, etc.).
  var keyboardType: UIKeyboardType = .default

  private let fieldTextColor = Color(red: 106 / 255.0, green: 114 / 255.0, blue: 130 / 255.0)

  var body: some View {
    // SwiftUI's TextField; title is empty because the styled prompt is the placeholder.
    TextField(
      "",
      text: $text,
      prompt: Text(placeholder).foregroundColor(fieldTextColor.opacity(0.6))
    )
    .font(.system(size: 16, weight: .regular))
    .foregroundColor(fieldTextColor)
    .keyboardType(keyboardType)
    .padding(.horizontal, 18)
    .frame(maxWidth: .infinity, minHeight: 52)
    .background(
      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .fill(Color.white)
        .shadow(color: Color.black.opacity(0.07), radius: 6, x: 0, y: 3)
    )
  }
}

#Preview {
  ZStack {
    Color(UIColor.systemGray6).ignoresSafeArea()

    CustomTextField(
      placeholder: "Tu texto aquí...",
      text: .constant("")  // Fakes Binding from text var
    )
    .padding()
  }
}
