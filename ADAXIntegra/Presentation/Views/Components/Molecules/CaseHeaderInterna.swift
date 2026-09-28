//
//  CaseHeader.swift
//  ADAXIntegra
//
//  Created by Nicolás Bravo Miguel on 22/09/26.
//

import SwiftUI

struct CaseHeader: View {
  let name: String
  let urgency: String

  private var urgencyVariant: Badge.Variant {
    switch urgency {
    case "Alta":
      return .alta
    case "Media":
      return .media
    case "Baja":
      return .baja
    default:
      return .sinEvaluar
    }
  }

  var body: some View {
    HStack {
      Text(name)
        .font(.system(size: 16, weight: .semibold))
        .foregroundColor(Color("OnBackground"))

      Spacer()

      Badge(label: urgency, variant: urgencyVariant)
    }
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    VStack(spacing: 12) {
      CaseHeader(name: "María López", urgency: "Alta")
      CaseHeader(name: "Ana Torres", urgency: "Media")
      CaseHeader(name: "Sofía Ramírez", urgency: "Baja")
      CaseHeader(name: "Lucía Fernández", urgency: "Sin evaluar")
    }
    .padding()
  }
}
