//
//  ProfileHeader.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 05/10/26.
//

import SwiftUI

// Card with the avatar, the full name and how long the user has had the account
struct ProfileHeader: View {
  let initials: String
  let fullName: String
  let memberSince: String

  var body: some View {
    SurfaceCard {
      HStack(spacing: 16) {
        UserAvatar(initials: initials)

        VStack(alignment: .leading, spacing: 4) {
          Text(fullName)
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(Color("OnBackground"))
            .lineLimit(1)
            .minimumScaleFactor(0.8)

          Text(memberSince)
            .font(.system(size: 13))
            .foregroundColor(Color("InsideTextAndIcons"))
        }

        Spacer(minLength: 0)
      }
      .padding(20)
    }
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    ProfileHeader(
      initials: "CH",
      fullName: "Celine Hernández Alonso",
      memberSince: "Desde jul 2024"
    )
    .padding()
  }
}
