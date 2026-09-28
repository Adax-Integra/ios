//
//  TextInput.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 21/09/26.
//

import SwiftUI

// Text-entry surface backed by "TextEditor"
struct TextInput: View {
  let placeholder: String
  @Binding var text: String
  var keyboardType: UIKeyboardType = .default

  var customWidth: CGFloat = .infinity
  var customHeight: CGFloat = 50

  // Optional hard cap on characters. When set, extra input is trimmed
  // to preserve the limit.
  var maxLength: Int? = nil

  @FocusState private var isFocused: Bool

  var body: some View {
    ZStack(alignment: .topLeading) {
      TextEditor(text: $text)
        .focused($isFocused)
        .font(.system(size: 16, weight: .regular))
        .foregroundColor(Color("OnBackground"))
        .keyboardType(keyboardType)
        .scrollContentBackground(.hidden)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .onChange(of: text) { _, newValue in
          guard let maxLength, newValue.count > maxLength else { return }
          text = String(newValue.prefix(maxLength))
        }

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
      maxWidth: customWidth,
      minHeight: customHeight,
      maxHeight: customHeight,
      alignment: .topLeading
    )
    .contentShape(Rectangle())
    .onTapGesture { isFocused = true }
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    SurfaceCard {
      TextInput(placeholder: "Tu texto aquí...", text: .constant(""))
    }
    .padding()
  }
}
