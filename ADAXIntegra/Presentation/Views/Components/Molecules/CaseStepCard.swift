//
//  CaseStepCard.swift
//  ADAXIntegra
//
//  Created by Lakshmi Jara on 15/10/26.
//

import SwiftUI

struct CaseStepCard: View {
  let title: String
  let description: String
  let status: CaseStepStatus

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack(alignment: .top) {
        Text(title)
          .font(.headline)

        Spacer(minLength: 8)

        Text(status.displayText)
          .font(.caption)
          .fontWeight(.semibold)
          .padding(.horizontal, 10)
          .padding(.vertical, 5)
          .background(Color("PrimaryAdax").opacity(0.1))
          .foregroundStyle(Color("PrimaryAdax"))
          .clipShape(Capsule())
      }

      Text(description)
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .fixedSize(horizontal: false, vertical: true)
    }
    .padding(16)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color("CardColor"))
    .clipShape(RoundedRectangle(cornerRadius: 16))
    .shadow(color: .black.opacity(0.08), radius: 2, y: 2)
  }
}
