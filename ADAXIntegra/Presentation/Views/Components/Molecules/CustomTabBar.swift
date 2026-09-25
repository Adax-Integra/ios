//
//  CustomTabBar.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 22/09/26.
//

import SwiftUI

enum AppTab: CaseIterable {
    case home, cases, profile

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .cases: return "folder.fill"
        case .profile: return "person.fill"
        }
    }

    var title: String {
        switch self {
        case .home: return "Inicio"
        case .cases: return "Mis Casos"
        case .profile: return "Perfil"
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        HStack {
            ForEach(AppTab.allCases, id: \.self) { tab in
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
        .padding(.bottom, 24) // respeta el safe area inferior
        .background(Color("CardColor"))
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: -2)
    }
}
