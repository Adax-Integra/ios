//
//  MenuTitleLabel.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 02/10/26.
//
import SwiftUI

struct MenuTitleLabel: View {
  let text: String
  var body: some View {
    Text(text)
      .font(.system(size: 16, weight: .semibold))
      .foregroundColor(Color("OnBackgroundColor"))
  }
}

struct MenuSubtitleLabel: View {
  let text: String
  var body: some View {
    Text(text)
      .font(.system(size: 13))
      .foregroundColor(Color("IconColor"))
  }
}
