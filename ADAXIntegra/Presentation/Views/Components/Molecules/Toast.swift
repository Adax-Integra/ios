//
//  Toast.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 23/09/26.
//

import SwiftUI
import UIKit

// color and icon of the toast so errors and confirmations stand out
enum ToastStyle {
  case info
  case success
  case error

  var background: Color {
    switch self {
    case .info: return Color("PrimaryAdax")
    case .success: return Color("DarkGreen")
    case .error: return Color("UrgencyHigh")
    }
  }

  var systemImage: String? {
    switch self {
    case .info: return nil
    case .success: return "checkmark.circle.fill"
    case .error: return "exclamationmark.triangle.fill"
    }
  }

  var fontWeight: Font.Weight {
    self == .info ? .regular : .semibold
  }

  // errors stay a little longer so there is time to read them
  var defaultDuration: Duration {
    self == .error ? .seconds(6) : .seconds(4)
  }

  var feedback: UINotificationFeedbackGenerator.FeedbackType? {
    switch self {
    case .info: return nil
    case .success: return .success
    case .error: return .error
    }
  }
}

//Molecule that shows a short message with an optional action
// (e.g. "Caso creado" + "Deshacer")
struct Toast: View {
  let message: String
  var style: ToastStyle = .info
  var actionTitle: String? = nil
  var action: (() -> Void)? = nil

  var body: some View {
    HStack(spacing: 12) {
      if let systemImage = style.systemImage {
        Image(systemName: systemImage)
          .font(.system(size: 18, weight: .semibold))
          .foregroundColor(.white)
          .accessibilityHidden(true)
      }

      Text(message)
        .font(.system(size: 15, weight: style.fontWeight))
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
        .fill(style.background)
    )
    .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
  }
}

//Presents a "Toast" anchored to the bottom of the view
//(or to the top with "edge") and hides it automatically after "duration"
extension View {
  func toast(
    isPresented: Binding<Bool>,
    message: String,
    style: ToastStyle = .info,
    duration: Duration? = nil,
    edge: VerticalEdge = .bottom,
    actionTitle: String? = nil,
    action: (() -> Void)? = nil
  ) -> some View {
    modifier(
      ToastModifier(
        isPresented: isPresented,
        message: message,
        style: style,
        duration: duration ?? style.defaultDuration,
        edge: edge,
        actionTitle: actionTitle,
        action: action
      )
    )
  }

}

private struct ToastModifier: ViewModifier {
  @Binding var isPresented: Bool
  let message: String
  let style: ToastStyle
  let duration: Duration
  let edge: VerticalEdge
  let actionTitle: String?
  let action: (() -> Void)?

  func body(content: Content) -> some View {
    content
      .overlay(alignment: edge == .top ? .top : .bottom) {
        if isPresented {
          Toast(
            message: message,
            style: style,
            actionTitle: actionTitle,
            action: actionTitle == nil
              ? nil
              : {
                action?()
                isPresented = false
              }
          )
          .padding(.horizontal)
          .padding(edge == .top ? .top : .bottom, 16)
          .transition(.move(edge: edge == .top ? .top : .bottom).combined(with: .opacity))
        }
      }
      .animation(.snappy, value: isPresented)
      .task(id: isPresented) {
        guard isPresented else { return }
        // success and error toasts vibrate and are read by voiceover when they appear
        if let feedback = style.feedback {
          UINotificationFeedbackGenerator().notificationOccurred(feedback)
          AccessibilityNotification.Announcement(message).post()
        }
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
