//
//  MenuRow.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 03/10/26.
//

import SwiftUI

struct MenuRow: View {
  let icon: String
  let title: String
  let subtitle: String

  var body: some View {
    HStack(spacing: 16) {
      MenuIcon(systemName: icon)
      VStack(alignment: .leading, spacing: 2) {
        MenuTitleLabel(text: title)
        MenuSubtitleLabel(text: subtitle)
      }
      Spacer()
      Image(systemName: "chevron.right")
        .font(.system(size: 14, weight: .semibold))
        .foregroundColor(Color("IconColor"))
    }
    .padding(16)
    .background(Color("CardColor"))
    .clipShape(RoundedRectangle(cornerRadius: 12))
  }
}
