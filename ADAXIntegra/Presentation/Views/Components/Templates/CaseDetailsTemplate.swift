//
//  CaseDetailsTemplate.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 02/10/26.
//

import SwiftUI

struct CaseDetailsTemplate<Content: View, BottomActions: View>: View {
  // Display number for the case shown in the header and the status of the case (Open/Closed).
  // The back button is the native one of the navigation bar
  var caseNumber: String
  var status: String

  @ViewBuilder var content: Content
  @ViewBuilder var bottomActions: BottomActions

  var body: some View {
    VStack(spacing: 0) {
      // Same title and status badge as before, only the custom back button was removed
      HStack(spacing: 12) {
        Text(" \(caseNumber)")
          .font(.title2)
          .fontWeight(.bold)
          .foregroundColor(.primary)

        StatusBadge(text: status)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal, 16)
      .padding(.top, 8)
      .padding(.bottom, 24)

      ScrollView(showsIndicators: false) {
        VStack(spacing: 16) {
          content
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
      }
      // Holds the close action buttons pinned to the bottom of the screen
      VStack {
        bottomActions
      }
      .padding(.horizontal, 16)
      .padding(.bottom, 16)
    }
    .background(Color("BackgroundColor").ignoresSafeArea())
    // Shows the native navigation bar (with the iOS back button) and no title,
    // because the case number is already displayed in the header above
    .navigationBarTitleDisplayMode(.inline)
  }
}
