//
//  ConfirmDialog.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 19/10/26.
//

//
//  ConfirmDialog.swift
//  ADAXIntegra
//

import SwiftUI

struct ConfirmDialogCard: View {
  let title: String
  var highlight: String? = nil
  var message: String? = nil
  var confirmTitle: String = "Confirmar"
  var cancelTitle: String = "Cancelar"
  var isConfirmDisabled: Bool = false
  let onConfirm: () -> Void
  let onCancel: () -> Void

  var body: some View {
    VStack(spacing: 20) {
      VStack(spacing: 8) {
        Text(title)
          .font(.system(size: 20, weight: .bold))
          .foregroundColor(Color("OnBackground"))
          .multilineTextAlignment(.center)

        if let highlight {
          Text(highlight)
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(Color("OnBackground"))
            .multilineTextAlignment(.center)
        }

        if let message {
          Text(message)
            .font(.system(size: 14))
            .foregroundColor(Color("InsideTextAndIcons"))
            .multilineTextAlignment(.center)
        }
      }
      .frame(maxWidth: .infinity)

      FormActions(
        primaryTitle: confirmTitle,
        secondaryTitle: cancelTitle,
        isPrimaryDisabled: isConfirmDisabled,
        onPrimary: onConfirm,
        onSecondary: onCancel
      )
    }
    .padding(24)
    .background(Color.white)
    .cornerRadius(28)
    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 4)
    .padding(.horizontal, 32)
  }
}

struct ConfirmDialog: View {
  let title: String
  var highlight: String? = nil
  var message: String? = nil
  var confirmTitle: String = "Confirmar"
  var cancelTitle: String = "Cancelar"
  var isConfirmDisabled: Bool = false
  let onConfirm: () -> Void
  let onCancel: () -> Void

  var body: some View {
    ZStack {
      Color.black.opacity(0.4)
        .ignoresSafeArea()
        .onTapGesture(perform: onCancel)

      ConfirmDialogCard(
        title: title,
        highlight: highlight,
        message: message,
        confirmTitle: confirmTitle,
        cancelTitle: cancelTitle,
        isConfirmDisabled: isConfirmDisabled,
        onConfirm: onConfirm,
        onCancel: onCancel
      )
    }
  }
}

extension View {
  @ViewBuilder
  func confirmDialog(
    isPresented: Binding<Bool>,
    title: String,
    highlight: String? = nil,
    message: String? = nil,
    confirmTitle: String = "Confirmar",
    cancelTitle: String = "Cancelar",
    isConfirmDisabled: Bool = false,
    onConfirm: @escaping () -> Void
  ) -> some View {
    overlay {
      if isPresented.wrappedValue {
        ConfirmDialog(
          title: title,
          highlight: highlight,
          message: message,
          confirmTitle: confirmTitle,
          cancelTitle: cancelTitle,
          isConfirmDisabled: isConfirmDisabled,
          onConfirm: {
            isPresented.wrappedValue = false
            onConfirm()
          },
          onCancel: { isPresented.wrappedValue = false }
        )
      }
    }
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()
    Text("Fondo")
  }
  .confirmDialog(
    isPresented: .constant(true),
    title: "Cerrar sesión",
    message: "¿Quieres cerrar tu sesión?",
    confirmTitle: "Cerrar sesión"
  ) {}
}
