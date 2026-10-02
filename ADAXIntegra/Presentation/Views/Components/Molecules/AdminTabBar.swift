//
//  AdminTabBar.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 01/10/26.
//

import SwiftUI

enum AdminTab: CaseIterable {
  case home, expedientes, profile, admin

  var icon: String {
    switch self {
    case .home: return "house.fill"
    case .expedientes: return "folder.fill"
    case .profile: return "person.fill"
    case .admin: return "wrench.and.screwdriver.fill"
    }
  }

  var title: String {
    switch self {
    case .home: return "Inicio"
    case .expedientes: return "Expedientes"
    case .profile: return "Perfil"
    case .admin: return "Administra"
    }
  }
}

struct CustomTabBarAdmin: View {
  @Binding var selectedTab: AdminTab

  var body: some View {
    HStack {
      ForEach(AdminTab.allCases, id: \.self) { tab in
        Button {
          selectedTab = tab
        } label: {
          VStack(spacing: 4) {
            Image(systemName: tab.icon)
              .font(.system(size: 22))
            Text(tab.title)
              .font(.system(size: 11, weight: .medium))
          }
          .foregroundColor(selectedTab == tab ? Color("PrimaryColor") : Color("IconColor"))
          .frame(maxWidth: .infinity)
        }
      }
    }
    .padding(.top, 10)
    .padding(.bottom, 24)
    .background(Color("CardColor"))
    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: -2)
  }
}

#Preview {
  PreviewWrapperAdmin()
}

private struct PreviewWrapperAdmin: View {
  @State private var selectedTab: AdminTab = .expedientes

  var body: some View {
    VStack {
      Spacer()
      CustomTabBarAdmin(selectedTab: $selectedTab)
    }
    .background(Color("BackgroundColor"))
  }
}
