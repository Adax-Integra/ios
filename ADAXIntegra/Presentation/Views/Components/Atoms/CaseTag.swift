//
//  CaseTag.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 06/10/26.
//

import SwiftUI

struct CaseTag: View {
  var width: CGFloat
  var height: CGFloat
  var rectangleColor: Color
  var textColor: Color
  var textSize: CGFloat
  var text: String

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 8)
        .fill(rectangleColor)
        .frame(width: width, height: height)

      Text(text)
        .foregroundStyle(textColor)
        .font(.system(size: textSize))
        .fontWeight(.heavy)
    }
  }
}

enum CaseStatus: String {
  case open = "Open"
  case closed = "Closed"

  var label: String {
    switch self {
    case .open:
      return "Abierto"
    case .closed:
      return "Cerrado"
    }
  }

  var tagBackgroundColor: Color {
    switch self {
    case .open:
      return Color(UIColor.systemGreen.withAlphaComponent(0.4))
    case .closed:
      return Color(UIColor.systemOrange.withAlphaComponent(0.2))
    }
  }

  var tagTextColor: Color {
    switch self {
    case .open:
      return Color("DarkGreen")
    case .closed:
      return Color("Error")
    }
  }
}

#Preview {
  CaseTag(
    width: 150,
    height: 50,
    rectangleColor: Color(UIColor.systemGreen.withAlphaComponent(0.4)),
    textColor: Color("DarkGreen"),
    textSize: 17,
    text: "Abierto"
  )
}
