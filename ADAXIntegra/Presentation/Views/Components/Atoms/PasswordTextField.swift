//
//  PasswordTextField.swift
//  ADAXIntegra
//
//  Created by Lakshmi Jara on 22/09/26.
//

import SwiftUI

struct PasswordTextField: View {
  var title: String
  let placeholder: String
  @Binding var text: String

  @State private var showPassword: Bool = false

  var body: some View {
    VStack(alignment: .leading) {
      Text(title)
        .font(.system(size: 16, weight: .regular))
        .foregroundColor(Color("OnBackground"))

      HStack {
        Image(systemName: "lock")
          .foregroundColor(Color("InsideTextAndIcons"))

        if showPassword {
          TextField(placeholder, text: $text)
        } else {
          SecureField(placeholder, text: $text)
        }

        Button {
          showPassword.toggle()
        } label: {
          Image(systemName: showPassword ? "eye" : "eye.slash")
            .foregroundColor(Color("InsideTextAndIcons"))
        }
      }
      .padding(.horizontal, 14)
      .frame(maxWidth: .infinity)
      .frame(height: 50)
      .background(Color.white)
      .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
      .shadow(color: Color.black.opacity(0.07), radius: 6, x: 0, y: 3)
    }
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()
    PasswordTextField(
      title: "Contraseña",
      placeholder: "Contraseña",
      text: .constant("")
    )
    .padding()
  }
}
