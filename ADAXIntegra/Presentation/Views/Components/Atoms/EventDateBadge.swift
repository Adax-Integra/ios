//
//  EventDateBadge.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 15/10/26.
//

import SwiftUI

// Small white square with the day and month, shown over the event image
struct EventDateBadge: View {
  let day: String
  let month: String

  var body: some View {
    VStack(spacing: 0) {
      Text(day)
        .font(.headline.bold())
      Text(month)
        .font(.caption2)
    }
    .foregroundColor(Color("OnBackground"))
    .frame(width: 44, height: 44)
    .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
    .shadow(color: .black.opacity(0.15), radius: 3, y: 1)
    .accessibilityElement(children: .combine)
  }
}

#Preview {
  EventDateBadge(day: "25", month: "OCT")
    .padding()
}
