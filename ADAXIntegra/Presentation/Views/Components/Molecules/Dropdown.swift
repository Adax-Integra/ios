//
//  Dropdown.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 21/09/26.
//

import SwiftUI

/*
 Dropdown component for selecting an option from a list.
 Uses the native "Menu" so the options float over the content instead of
 pushing the layout down, and adapts to each iOS version's system style
*/
struct Dropdown: View {
  var customWidth: CGFloat = .infinity
  var customHeight: CGFloat = 52

  let title: String
  let prompt: String
  let options: [String]

  // Blocks the dropdown and dims it, used while another field must be filled first.
  var isDisabled: Bool = false

  @Binding var selection: String?

  // An empty string counts as nothing selected, so the prompt is shown
  private var selectedText: String? {
    guard let selection, !selection.isEmpty else { return nil }
    return selection
  }

  var body: some View {
    VStack(alignment: .leading) {
      if !title.isEmpty {
        FieldLabel(title)
      }

      Menu {
        // Inline picker shows a checkmark next to the current selection
        Picker(title, selection: $selection) {
          ForEach(options, id: \.self) { option in
            Text(option).tag(Optional(option))
          }
        }
      } label: {
        SurfaceCard {
          HStack {
            Text(selectedText ?? prompt)
              .foregroundStyle(
                selectedText == nil ? Color("InsideTextAndIcons").opacity(0.6) : .primary
              )
              .lineLimit(1)

            Spacer()

            Chevron(
              direction: .down,  // atom renders this as a downward chevron
              size: 12,
              customColor: "InsideTextAndIcons"
            )
          }
          .frame(height: customHeight)
          .padding(.horizontal)
          .frame(maxWidth: customWidth)
          .contentShape(Rectangle())  // Makes the whole rectangle area tappable
        }
      }
      // Keeps the options in the same order whether the menu opens up or down
      .menuOrder(.fixed)
      .tint(Color("PrimaryAdax"))
      .disabled(isDisabled)
      .opacity(isDisabled ? 0.5 : 1)
    }
    .frame(maxWidth: .infinity)
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    VStack(spacing: 24) {
      Dropdown(
        title: "País",
        prompt: "Selecciona un país",
        options: ["México", "Estados Unidos", "Canadá"],
        selection: .constant("México")
      )

      // Long list: the native menu scrolls on its own
      Dropdown(
        title: "Estado",
        prompt: "Selecciona un estado",
        options: [
          "Aguascalientes", "Baja California", "Baja California Sur",
          "Campeche", "Chiapas", "Chihuahua", "Ciudad de México",
          "Coahuila", "Colima", "Durango",
        ],
        selection: .constant(nil)
      )
    }
    .padding()
  }
}
