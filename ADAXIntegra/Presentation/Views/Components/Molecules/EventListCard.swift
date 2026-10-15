//
//  EventListCard.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 15/10/26.
//

import SwiftUI

// Full card for the events list page of US E-01
struct EventListCard: View {
  let event: Event

  var body: some View {
    SurfaceCard(cornerRadius: 20) {
      VStack(alignment: .leading, spacing: 0) {
        EventCoverImage(url: event.imageURL, height: 140)
          .overlay(alignment: .topLeading) {
            EventDateBadge(day: event.dayString, month: event.monthString)
              .padding(10)
          }

        VStack(alignment: .leading, spacing: 6) {
          HStack(alignment: .top, spacing: 8) {
            Text(event.title)
              .font(.subheadline.bold())
              .foregroundColor(Color("OnBackground"))
              .lineLimit(2)

            Spacer(minLength: 8)

            Text(event.timeString)
              .font(.caption.bold())
              .foregroundColor(Color("PrimaryAdax"))
              .padding(.horizontal, 10)
              .padding(.vertical, 4)
              .background(Color("PrimaryAdax").opacity(0.12), in: Capsule())
          }

          if let description = event.description, !description.isEmpty {
            Text(description)
              .font(.caption)
              .foregroundColor(Color("SecondaryAdax"))
              .lineLimit(2)
          }

          if let place = event.displayLocation {
            Label(place, systemImage: "mappin.and.ellipse")
              .font(.caption2)
              .foregroundColor(Color("SecondaryAdax"))
              .lineLimit(1)
          }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
      }
      .clipShape(RoundedRectangle(cornerRadius: 20))
    }
  }
}
