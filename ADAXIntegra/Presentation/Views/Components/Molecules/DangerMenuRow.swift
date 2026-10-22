//
//  DangerMenuRow.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 17/10/26.
//

import SwiftUI

struct DangerMenuRow: View {
  let icon: String
  let title: String
  let subtitle: String

  var body: some View {
    HStack(spacing: 16) {
      Image(systemName: icon)
        .font(.system(size: 20))
        .frame(width: 32)
      VStack(alignment: .leading, spacing: 2) {
        Text(title).font(.system(size: 16, weight: .semibold))
        Text(subtitle).font(.system(size: 13))
      }
      Spacer()
      Image(systemName: "chevron.right")
        .font(.system(size: 14, weight: .semibold))
    }
    .foregroundColor(Color("ErrorColor"))
    .padding(16)
    .background(Color("ErrorColor").opacity(0.12))
    .clipShape(RoundedRectangle(cornerRadius: 12))
  }
}
