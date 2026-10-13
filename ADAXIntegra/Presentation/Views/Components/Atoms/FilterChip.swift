//
//  FilterChip.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 07/10/26.
//

import SwiftUI

struct FilterChip: View {
  let title: String
  var isActive: Bool = false

  var body: some View {
    HStack(spacing: 6) {
      Image(systemName: "line.3.horizontal.decrease")
      Text(title)
    }
    .font(.system(size: 13, weight: .semibold))
    .foregroundStyle(Color("OnBackground"))
    .padding(.horizontal, 14)
    .padding(.vertical, 8)
    .background(
      Capsule().fill(isActive ? Color("PrimaryAdax").opacity(0.2) : Color.gray.opacity(0.2))
    )
  }
}
