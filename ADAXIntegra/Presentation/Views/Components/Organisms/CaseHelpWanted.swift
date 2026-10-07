//
//  CaseHelpWanted.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 01/10/26.
// Case description of help wanted by the external user   for details of a particular case for US V-11

import SwiftUI

struct CaseHelpWanted: View {
  var helpwanted: String

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text(" Ayuda requerida del caso")
        .font(.system(size: 16, weight: .bold))
        .foregroundColor(.primary)

      Text(helpwanted)
        .font(.system(size: 14))
        .foregroundColor(Color.primary.opacity(0.8))
        .lineSpacing(4)
    }
    .padding(16)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color.white)
    .cornerRadius(16)
    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
  }
}

#Preview {
  ZStack {
    Color(UIColor.systemGray6).ignoresSafeArea()

    CaseHelpWanted(
      helpwanted:
        "La externa busca La externa busca tener un  acompañamiento en la presentación de denuncia formal y juicio de divorcio."
    )
    .padding()
  }
}
