//
//  ChangeRow.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 06/10/26.
//

import SwiftUI

// Molecule that shows the old and the new value of a changed field
struct ChangeRow: View {
  let change: ExternalProfileChange

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text(change.label.uppercased())
        .font(.system(size: 12, weight: .semibold))
        .foregroundColor(Color("InsideTextAndIcons"))

      HStack(spacing: 8) {
        Text(change.oldValue)
          .strikethrough()
          .foregroundColor(Color("InsideTextAndIcons"))

        Image(systemName: "arrow.right")
          .foregroundColor(Color("PrimaryAdax"))

        Text(change.newValue)
          .fontWeight(.semibold)
          .foregroundColor(Color("OnBackground"))
      }
      .font(.system(size: 15))
    }
    .padding(.horizontal, 14)
    .padding(.vertical, 12)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(
      RoundedRectangle(cornerRadius: 12, style: .continuous)
        .fill(Color("PrimaryAdax").opacity(0.06))
    )
  }
}

#Preview {
  ChangeRow(
    change: ExternalProfileChange(
      label: "Colonia", oldValue: "Centro", newValue: "Jurica"
    )
  )
  .padding()
}
