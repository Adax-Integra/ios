//
//  HomeHeader.swift
//  ADAXIntegra
//
//  Created by Lakshmi Jara on 06/10/26.
//

import SwiftUI

// header for the external home screen

struct HomeHeader: View {
  let onNotificationsTap: () -> Void

  var body: some View {
    Image("AdaxLogo")
      .resizable()
      .scaledToFit()
      .frame(width: 240, height: 100)
      .frame(maxWidth: .infinity)
      .overlay(alignment: .topTrailing) {
        Button(action: onNotificationsTap) {
          Image(systemName: "bell")
            .font(.title2)
            .foregroundColor(Color("InsideTextAndIcons"))
            .frame(width: 44, height: 44)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Notificaciones")
      }
  }
}

#Preview {
  ZStack {
    Color("Backgroung").ignoresSafeArea()

    HomeHeader(onNotificationsTap: {})
      .padding(20)
  }
}
