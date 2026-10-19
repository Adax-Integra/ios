//
//  ActivityLogTimelineRow.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 18/10/26.
//

import SwiftUI

// Organism that acts like a timeline for the log
// shows time on the left and the card on the right
struct ActivityLogTimelineRow: View {
  let log: ActivityLogItem

  private let timeWidth: CGFloat = 72
  private let lineWidth: CGFloat = 4

  var body: some View {
    HStack(spacing: 0) {
      // Time of the action, formatted by the Date utils
      Text(log.timeString)
        .font(.system(size: 13, weight: .bold))
        .foregroundColor(Color("PrimaryAdax"))
        .minimumScaleFactor(0.7)
        .lineLimit(1)
        .frame(width: timeWidth, alignment: .leading)

      // Empty space reserved for the line drawn in the background
      Color.clear.frame(width: lineWidth)

      ActivityLogCard(
        iconName: log.iconName,
        title: log.actionLabel,
        description: log.description
      )
      .padding(.leading, 12)
      .padding(.vertical, 6)
    }
    .background(alignment: .leading) {
      // The line takes the full height of the row
      Rectangle()
        .fill(Color("PrimaryAdax"))
        .frame(width: lineWidth)
        .padding(.leading, timeWidth)
    }
  }
}
