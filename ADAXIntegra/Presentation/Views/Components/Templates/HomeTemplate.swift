//
//  HomeTemplate.swift
//  ADAXIntegra
//
//  Created by Lakshmi Jara on 06/10/26.
//

import SwiftUI

// layout for the external home screen
struct HomeTemplate<Header: View, Welcome: View, CaseProgress: View, Events: View, Podcast: View>:
  View
{

  // home sections
  @ViewBuilder let header: () -> Header
  @ViewBuilder let welcome: () -> Welcome
  @ViewBuilder let caseProgress: () -> CaseProgress
  @ViewBuilder let events: () -> Events
  @ViewBuilder let podcast: () -> Podcast

  // layout
  var horizontalPadding: CGFloat = 20
  var sectionSpacing: CGFloat = 24

  var body: some View {
    ZStack {
      Color("Background").ignoresSafeArea()

      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: 8) {
          header()
          welcome()

          // components provided by the case and events US
          caseProgress()
          events()

          podcast()
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, 16)
      }
    }
  }
}

#Preview {
  HomeTemplate {
    Text("ADAX INTEGRA")
      .font(.title2.bold())
      .foregroundColor(Color("PrimaryAdax"))
  } welcome: {
    Text("¡Hola!")
      .font(.largeTitle.bold())
  } caseProgress: {
    SurfaceCard(cornerRadius: 28) {
      Text("Tu caso en curso")
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .frame(minHeight: 120, alignment: .topLeading)
        .padding(20)
    }
  } events: {
    VStack(alignment: .leading, spacing: 12) {
      Text("Eventos")
        .font(.title2.bold())

      Color.clear.frame(height: 200)
    }
  } podcast: {
    VStack(alignment: .leading, spacing: 12) {
      Text("Podcast")
        .font(.title2.bold())

      PodcastCard(onTap: {})
    }
  }
}
