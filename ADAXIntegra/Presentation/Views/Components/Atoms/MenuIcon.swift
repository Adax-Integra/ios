//
//  MenuIcon.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 02/10/26.
//

import SwiftUI

struct MenuIcon: View {
  let systemName: String
  var body: some View {
    Image(systemName: systemName)
      .font(.system(size: 20))
      .foregroundColor(Color("OnBackgroundColor"))
      .frame(width: 32)
  }
}
