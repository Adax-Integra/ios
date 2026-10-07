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
  case active = "Activo"
  case attended = "Atentido"
  case closed = "Cerrado"

  var tagBackgroundColor: Color {
    switch self {
    case .active:
      return Color(UIColor.systemGreen.withAlphaComponent(0.4))
    case .attended:
      return Color(UIColor.systemPurple.withAlphaComponent(0.3))
    case .closed:
      return Color(UIColor.systemGray.withAlphaComponent(0.3))
    }
  }

  var tagTextColor: Color {
    switch self {
    case .active:
      return Color("DarkGreen")
    case .attended:
      return Color("PrimaryAdax")
    case .closed:
      return Color("DarkGray")
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
    text: "Activo"
  )
}
