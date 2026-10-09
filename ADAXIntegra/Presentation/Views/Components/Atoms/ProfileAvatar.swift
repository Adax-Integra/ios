//
//  ProfileAvatar.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 30/09/26.
//
// Profile Avatar atom for thegeneral info card of US v-11 getCaseDetails

import SwiftUI

struct ProfileAvatar: View {
  var size: CGFloat = 48

  var body: some View {
    ZStack {
      // clear background
      Circle()
        .fill(Color("PrimaryAdax").opacity(0.1))
        .frame(width: size, height: size)

      //avatar icon
      Image(systemName: "person")
        .font(.system(size: size * 0.45, weight: .semibold))
        .foregroundColor(Color("PrimaryAdax"))
    }

  }
}

#Preview {
  ProfileAvatar()
}
