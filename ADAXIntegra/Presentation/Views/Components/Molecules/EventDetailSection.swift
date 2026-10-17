//
//  EventDetailSection.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 15/10/26.
//
import SwiftUI

// Purple uppercase title 
struct EventDetailSection: View {
  let title: String
  let text: String
  var systemImage: String? = nil

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      HStack(spacing: 6) {
        if let systemImage {
          Image(systemName: systemImage)
        }
        Text(title)
          .textCase(.uppercase)
      }
      .font(.headline)
      .foregroundColor(Color("PrimaryAdax"))

      Text(text)
        .font(.subheadline)
        .foregroundColor(Color("OnBackground"))
        .fixedSize(horizontal: false, vertical: true)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .accessibilityElement(children: .combine)
  }
}

#Preview {
  EventDetailSection(
    title: "Fecha y hora",
    text: "Miércoles 3 de septiembre, 2026 · 10:00-11:30 AM",
    systemImage: "clock"
  )
  .padding()
}
