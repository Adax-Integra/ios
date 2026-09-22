//
//  Dropdown.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 19/09/26.
//

import SwiftUI

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
        Text(title)
          .font(.system(size: 16, weight: .regular))
          .foregroundColor(Color("OnBackground"))
      }

      VStack {
        HStack {
          Text(selection ?? prompt)

          Spacer()

          Image(systemName: "chevron.down")
            .font(.subheadline)
            .foregroundStyle(Color("InsideTextAndIcons"))
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
      .background(.white)
      .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
      .shadow(color: Color.black.opacity(0.07), radius: 6, x: 0, y: 3)
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
