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

  @State private var isExpanded = false
  @Binding var selection: String?

  var body: some View {
    VStack(alignment: .leading) {
      if !title.isEmpty {
        FieldLabel(title)
      }

      SurfaceCard {
        VStack {
          HStack {
            Text(selection ?? prompt)

            Spacer()

            Chevron(
              direction: .up,  // atom renders this as a downward chevron
              size: 12,
              customColor: "InsideTextAndIcons"
            )
            .rotationEffect(.degrees(isExpanded ? 180 : 0))
          }
          .frame(height: customHeight)
          .contentShape(Rectangle())  // Makes the whole rectangle area tappable
          .padding(.horizontal)
          .onTapGesture {
            withAnimation(.snappy) { isExpanded.toggle() }
          }

          if isExpanded {
            VStack {
              ForEach(options, id: \.self) { option in
                HStack {
                  Text(option)
                    .foregroundStyle(
                      selection == option ? Color("PrimaryAdax") : Color("InsideTextAndIcons")
                    )
                    .fontWeight(selection == option ? .bold : .regular)

                  Spacer()

                }
                .frame(height: 40)
                .padding(.horizontal)
                .onTapGesture {
                  withAnimation(.snappy) {
                    selection = option
                    isExpanded.toggle()
                  }
                }
              }
            }
            .transition(.move(edge: .bottom))
          }

        }
        .frame(maxWidth: customWidth)
      }
    }
    .frame(maxWidth: .infinity)
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    Dropdown(
      customWidth: .infinity,
      customHeight: 52,
      title: "País", prompt: "Selecciona un país",
      options: [
        "México",
        "Estados Unidos",
        "Canadá",
      ], selection: .constant("México"),
    )
    .padding()
  }
}
