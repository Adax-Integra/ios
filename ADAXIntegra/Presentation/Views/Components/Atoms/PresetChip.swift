//
//  PresetChip.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 15/10/26.
//

import SwiftUI

struct PresetChip: View {
  let title: String
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      Text(title)
        .font(.system(size: 14, weight: .semibold))
        .foregroundColor(.white)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(Color("PrimaryColor"))
        .clipShape(Capsule())
    }
  }
}
