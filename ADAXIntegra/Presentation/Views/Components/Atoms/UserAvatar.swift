//
//  UserAvatar.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 05/10/26.
//

import SwiftUI

// Circle with the user's initials, used as the profile picture
struct UserAvatar: View {
  let initials: String
  var size: CGFloat = 72

  var body: some View {
    Text(initials)
      .font(.system(size: size * 0.4, weight: .medium))
      .foregroundColor(.white)
      .frame(width: size, height: size)
      .background(Color("PrimaryAdax"))
      .clipShape(Circle())
  }
}

#Preview {
  UserAvatar(initials: "CH")
}
