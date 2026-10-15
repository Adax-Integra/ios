//
//  EventCoverImage.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 15/10/26.
//

import SwiftUI

// Event image with a default look while loading or an error or when there is no image
struct EventCoverImage: View {
  let url: URL?
  let height: CGFloat

  var body: some View {
    Color.clear
      .frame(maxWidth: .infinity)
      .frame(height: height)
      .background(placeholder)
      .overlay {
        if let url {
          AsyncImage(url: url) { phase in
            if let image = phase.image {
              image
                .resizable()
                .scaledToFill()
            }
          }
        }
      }
      .clipped()
      .accessibilityHidden(true)
  }

  private var placeholder: some View {
    ZStack {
        Color("SecondaryAdax").opacity(0.20)
              
              Image(systemName: "calendar")
                .font(.largeTitle)
                .foregroundColor(Color("PrimaryAdax").opacity(0.6))
            }
          }
        }

        #Preview {
          EventCoverImage(url: nil, height: 120)
            .padding()
        }
