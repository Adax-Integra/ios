//
//  PrivacyNoticeSummary.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 02/10/26.
//

import SwiftUI

// Card that summarizes the privacy notice in five numbered sections
struct PrivacyNoticeSummary: View {
  var body: some View {
    SurfaceCard {
      VStack(spacing: 12) {
        NumberedInfoRow(
          number: 1,
          title: "¿Qué datos recopilamos?",
          description:
            "El aviso especifica nombre, edad/fecha de nacimiento, teléfono, correo, domicilio, INE y comprobante de domicilio."
        )
        Divider()
        NumberedInfoRow(
          number: 2,
          title: "¿Cómo usamos tus datos?",
          description:
            "Para integrar tu expediente y darte seguimiento."
        )
        Divider()
        NumberedInfoRow(
          number: 3,
          title: "Protección de tu información",
          description:
            "Guardamos tu información de forma segura y solo la consulta el personal que atiende tu caso."
        )
        Divider()
        NumberedInfoRow(
          number: 4,
          title: "Compartición de datos",
          description: "No compartimos tu información con terceros, salvo obligación legal."
        )
        Divider()
        NumberedInfoRow(
          number: 5,
          title: "Tus derechos",
          description:
            "Puedes acceder, rectificar o solicitar la eliminación de tus datos en cualquier momento."
        )
      }
      .padding(16)
    }
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    PrivacyNoticeSummary()
      .padding()
  }
}
