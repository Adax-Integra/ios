//
//  BackToolbarButton.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 19/10/26.
//

import SwiftUI

// Native back button for the first page of a full screen cover, where iOS has no page to go back to
extension View {
  func backToolbarButton(action: @escaping () -> Void) -> some View {
    modifier(BackToolbarButtonModifier(action: action))
  }
}

private struct BackToolbarButtonModifier: ViewModifier {
  let action: () -> Void

  func body(content: Content) -> some View {
    content
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button(action: action) {
            Image(systemName: "chevron.left")
          }
          .accessibilityLabel("Regresar")
        }
      }
  }
}

#Preview {
  NavigationStack {
    Text("Contenido")
      .navigationTitle("Título")
      .backToolbarButton {}
  }
}
