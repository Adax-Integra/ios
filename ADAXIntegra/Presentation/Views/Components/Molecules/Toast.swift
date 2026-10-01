//
//  Toast.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 23/09/26.
//

import SwiftUI

//Molecule that shows a short message with an optional action
// (e.g. "Caso creado" + "Deshacer")
struct Toast: View {
  let message: String
  var actionTitle: String? = nil
  var action: (() -> Void)? = nil

  var body: some View {
    HStack(spacing: 12) {
      Text(message)
        .font(.system(size: 15, weight: .regular))
        .foregroundColor(.white)

      Spacer(minLength: 0)

      if let actionTitle, let action {
        Button(actionTitle, action: action)
          .font(.system(size: 15, weight: .bold))
          .foregroundColor(.white)
      }
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 14)
    .background(
      RoundedRectangle(cornerRadius: 12, style: .continuous)
        .fill(Color("PrimaryAdax"))
    )
    .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
  }
}

//Presents a "Toast" anchored to the bottom of the view and hides it
// automatically after "duration"
extension View {
  func toast(
    isPresented: Binding<Bool>,
    message: String,
    duration: Duration = .seconds(4),
    actionTitle: String? = nil,
    action: (() -> Void)? = nil
  ) -> some View {
    modifier(
      ToastModifier(
        isPresented: isPresented,
        message: message,
        duration: duration,
        actionTitle: actionTitle,
        action: action
      )
    )
  }

}

private struct ToastModifier: ViewModifier {
  @Binding var isPresented: Bool
  let message: String
  let duration: Duration
  let actionTitle: String?
  let action: (() -> Void)?

  func body(content: Content) -> some View {
    content
      .overlay(alignment: .bottom) {
        if isPresented {
          Toast(
            message: message,
            actionTitle: actionTitle,
            action: actionTitle == nil
              ? nil
              : {
                action?()
                isPresented = false
              }
          )
          .padding(.horizontal)
          .padding(.bottom, 16)
          .transition(.move(edge: .bottom).combined(with: .opacity))
        }
      }
      .animation(.snappy, value: isPresented)
      .task(id: isPresented) {
        guard isPresented else { return }
        try? await Task.sleep(for: duration)
        guard !Task.isCancelled else { return }
        isPresented = false
      }
  }
}

#Preview {
  @Previewable @State var showToast = true

  ZStack {
    Color("Background").ignoresSafeArea()

    Button("Mostrar toast") { showToast = true }
  }
  .toast(
    isPresented: $showToast,
    message: "Caso creado",
    actionTitle: "Deshacer",
    action: { print("Deshacer") }
  )
}
