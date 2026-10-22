//
//  PillTabSelector.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 17/10/26.
//

import SwiftUI

// Molecule with a pill shaped tab for the details of a internal account with
// General/Casos
struct PillTabSelector<Tab: Hashable>: View {
  let tabs: [Tab]
  @Binding var selection: Tab
  let title: (Tab) -> String

  var body: some View {
    HStack(spacing: 4) {
      ForEach(tabs, id: \.self) { tab in
        Button {
          selection = tab
        } label: {
          Text(title(tab))
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(selection == tab ? .white : Color("InsideTextAndIcons"))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
              RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(selection == tab ? Color("PrimaryAdax") : Color.clear)
            )
        }
        .buttonStyle(.plain)
      }
    }
    .padding(6)
    .background(
      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .fill(Color.white)
    )
    .animation(.snappy, value: selection)
  }
}

#Preview {
  @Previewable @State var selection = "General"

  PillTabSelector(tabs: ["General", "Casos"], selection: $selection) { $0 }
    .padding()
    .background(Color("Background"))
}
