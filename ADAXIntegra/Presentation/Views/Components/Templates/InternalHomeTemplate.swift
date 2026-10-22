//
//  InternalHomeTemplate.swift
//  ADAXIntegra
//
//  Created by Lakshmi Jara on 12/10/26.
//

import SwiftUI

// layout shared by the internal and admin home screens
struct InternalHomeTemplate<
  Header: View, Welcome: View, Records: View, Events: View, SocialMedia: View, Podcast: View
>: View {
  @ViewBuilder let header: () -> Header
  @ViewBuilder let welcome: () -> Welcome
  @ViewBuilder let records: () -> Records
  @ViewBuilder let events: () -> Events
  @ViewBuilder let podcast: () -> Podcast
  @ViewBuilder let socialMedia: () -> SocialMedia

  var body: some View {
    ZStack {
      Color("Background")
        .ignoresSafeArea()

      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: 24) {
          header()
          welcome()
          records()
          events()
          podcast()
          socialMedia()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
      }
    }
  }
}
