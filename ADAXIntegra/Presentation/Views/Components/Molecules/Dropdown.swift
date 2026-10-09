//
//  Dropdown.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 21/09/26.
//

import SwiftUI

// Dropdown component for selecting an option from a list
struct Dropdown: View {
  var customWidth: CGFloat = .infinity
  var customHeight: CGFloat = 52

  let title: String
  let prompt: String
  let options: [String]

  // Height of a single option row when the list is expanded
  var optionHeight: CGFloat = 40

  // Maximum number of options rendered at once when the list is expanded.
  // If "options.count" exceeds this value, the expanded list becomes
  // vertically scrollable and its height is capped at
  // "maxVisibleOptions * optionHeight". Set to "nil" to always show every
  // option without scrolling
  var maxVisibleOptions: Int? = 6

  // Blocks the dropdown and dims it, used while another field must be filled first.
  var isDisabled: Bool = false

  @State private var isExpanded = false
  @Binding var selection: String?

  // An empty string counts as nothing selected, so the prompt is shown
  private var selectedText: String? {
    guard let selection, !selection.isEmpty else { return nil }
    return selection
  }

  // Max height for the expanded options container.
  private var expandedMaxHeight: CGFloat? {
    guard let maxVisibleOptions, options.count > maxVisibleOptions else { return nil }
    return CGFloat(maxVisibleOptions) * optionHeight
  }

  var body: some View {
    VStack(alignment: .leading) {
      if !title.isEmpty {
        FieldLabel(title)
      }

      SurfaceCard {
        VStack {
          HStack {
            Text(selectedText ?? prompt)
              .foregroundColor(
                selectedText == nil ? Color("InsideTextAndIcons").opacity(0.6) : nil
              )

            Spacer()

            Chevron(
              direction: .down,  // atom renders this as a downward chevron
              size: 12,
              customColor: "InsideTextAndIcons"
            )
            .rotationEffect(.degrees(isExpanded ? 180 : 0))
          }
          .frame(height: customHeight)
          .contentShape(Rectangle())  // Makes the whole rectangle area tappable
          .padding(.horizontal)
          .onTapGesture {
            guard !isDisabled else { return }
            withAnimation(.snappy) { isExpanded.toggle() }
          }

          if isExpanded {
            expandedList
              .transition(.move(edge: .bottom))
          }

        }
        .frame(maxWidth: customWidth)
      }
      .opacity(isDisabled ? 0.5 : 1)
    }
    .frame(maxWidth: .infinity)
  }

  // When the list already fits within "maxVisibleOptions" (or the cap is
  // disabled), we render a plain "VStack" so the dropdown hugs its content.
  //
  // Only when the list exceeds the cap, we wrap it in a
  // "ScrollView" whose height is pinned to exactly
  // "maxVisibleOptions * optionHeight", so the row area stops growing and
  // scrolling takes over
  @ViewBuilder
  private var expandedList: some View {
    let rows = VStack(spacing: 0) {
      ForEach(options, id: \.self) { option in
        optionRow(option)
      }
    }

    if let expandedMaxHeight {
      ScrollView { rows }
        .frame(height: expandedMaxHeight)
    } else {
      rows
    }
  }

  private func optionRow(_ option: String) -> some View {
    HStack {
      Text(option)
        .foregroundStyle(
          selection == option ? Color("PrimaryAdax") : Color("InsideTextAndIcons")
        )
        .fontWeight(selection == option ? .bold : .regular)

      Spacer()
    }
    .frame(height: optionHeight)
    .padding(.horizontal)
    .contentShape(Rectangle())
    .onTapGesture {
      withAnimation(.snappy) {
        selection = option
        isExpanded.toggle()
      }
    }
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    VStack(spacing: 24) {
      // Short list: fits below the cap, so no scrolling
      Dropdown(
        title: "País",
        prompt: "Selecciona un país",
        options: ["México", "Estados Unidos", "Canadá"],
        selection: .constant("México")
      )

      // Long list: caps at "maxVisibleOptions" rows and becomes scrollable
      Dropdown(
        title: "Estado",
        prompt: "Selecciona un estado",
        options: [
          "Aguascalientes", "Baja California", "Baja California Sur",
          "Campeche", "Chiapas", "Chihuahua", "Ciudad de México",
          "Coahuila", "Colima", "Durango",
        ],
        maxVisibleOptions: 5,
        selection: .constant(nil)
      )
    }
    .padding()
  }
}
