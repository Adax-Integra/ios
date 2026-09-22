//
//  TextField.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 16/09/26.
//

import SwiftUI

struct CustomTextField: View {
  var customWidth: CGFloat = 200
  var minHeight: CGFloat = 50
  var maxHeight: CGFloat = 50
  var title: String

  let placeholder: String

  @Binding var text: String
  @FocusState private var isFocused: Bool

  // Keyboard layout for this field (email, number, default, etc.).
  var keyboardType: UIKeyboardType = .default

  var body: some View {
    VStack(alignment: .leading) {
      if !title.isEmpty {
        Text(title)
          .font(.system(size: 16, weight: .regular))
          .foregroundColor(Color("OnBackground"))
      }

      ZStack(alignment: .topLeading) {
        TextEditor(text: $text)
          .focused($isFocused)
          .font(.system(size: 16, weight: .regular))
          .foregroundColor(Color("OnBackground"))
          .keyboardType(keyboardType)
          .scrollContentBackground(.hidden)
          .padding(.horizontal, 14)
          .padding(.vertical, 8)

        if text.isEmpty {
          Text(placeholder)
            .font(.system(size: 16, weight: .regular))
            .foregroundColor(Color("InsideTextAndIcons").opacity(0.6))
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .allowsHitTesting(false)
        }
      }
      .frame(
        maxWidth: customWidth, minHeight: minHeight, maxHeight: maxHeight, alignment: .topLeading
      )
      .background(
        RoundedRectangle(cornerRadius: 16, style: .continuous)
          .fill(Color.white)
          .shadow(color: Color.black.opacity(0.07), radius: 6, x: 0, y: 3)
      )
      .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
      .onTapGesture { isFocused = true }
    }
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    CustomTextField(
      customWidth: .infinity,
      minHeight: 50,
      maxHeight: 50,
      title: "Describe tu caso",
      placeholder: "Tu texto aquí...",
      text: .constant("")
    )
    .padding()
  }
}
