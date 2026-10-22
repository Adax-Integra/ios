//
//  StepOptionRow.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 18/10/26.
//

import SwiftUI

struct StepOptionRow: View {
  let title: String
  let isSelected: Bool
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      HStack(spacing: 12) {
        Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
          .font(.system(size: 20))
          .foregroundColor(isSelected ? Color("PrimaryAdax") : Color("InsideTextAndIcons"))
        Text(title)
          .font(.system(size: 15, weight: isSelected ? .semibold : .regular))
          .foregroundColor(Color("OnBackground"))
        Spacer()
      }
      .padding(.vertical, 8)
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
  }
}
