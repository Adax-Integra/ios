//
//  HomeHeader.swift
//  ADAXIntegra
//
//  Created by Lakshmi Jara on 06/10/26.
//

import SwiftUI

// header for the external home screen

struct HomeHeader: View {

  var body: some View {
    Image("AdaxLogo")
      .resizable()
      .scaledToFit()
      .frame(width: 240, height: 100)
      .frame(maxWidth: .infinity)
  }
}

#Preview {
  ZStack {
    Color("Backgroung").ignoresSafeArea()

    HomeHeader()
      .padding(20)
  }
}
