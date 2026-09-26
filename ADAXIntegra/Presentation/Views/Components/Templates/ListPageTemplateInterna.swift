//
//  ListPageTemplate.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 23/09/26.
//

import SwiftUI

struct ListPageTemplate<Header: View, Toolbar: View, Content: View>: View {

  @ViewBuilder let header: () -> Header
  @ViewBuilder let toolbar: () -> Toolbar
  @ViewBuilder let content: () -> Content

  var body: some View {
    ZStack {
      Color("Background").ignoresSafeArea()

      VStack(alignment: .leading, spacing: 0) {
        header()
          .padding(.horizontal, 16)
          .padding(.top, 8)

        toolbar()
          .padding(.horizontal, 16)
          .padding(.top, 24)

        ScrollView {
          VStack(spacing: 16) {
            content()
          }
          .padding()
        }

      }
    }
  }
}

#Preview {
  ListPageTemplate {
    Text("Header")
      .font(.largeTitle.bold())
  } toolbar: {
    RoundedRectangle(cornerRadius: 16)
      .fill(Color.gray.opacity(0.3))
      .frame(height: 100)
  } content: {
    ForEach(0..<3) { _ in
      RoundedRectangle(cornerRadius: 16)
        .fill(Color.white)
        .frame(height: 220)
    }
  }
}

