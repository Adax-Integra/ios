//
//  CaseDescriptionCard.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 01/10/26.
// Case description card for details of a particular case for US V-11

import SwiftUI

struct CaseDescriptionCard: View {
  var description: String

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("Descripción del Caso")
        .font(.system(size: 16, weight: .bold))
        .foregroundColor(.primary)

      Text(description)
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

    CaseDescriptionCard(
      description:
        "Se realizó la segunda sesión de acompañamiento psicológico. La beneficiaria muestra avances en el manejo de ansiedad. Se recomienda continuar con sesiones semanales."
    )
    .padding()
  }
}
