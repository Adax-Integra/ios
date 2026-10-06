//
//  ConsentCheckboxRow.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 02/10/26.
//

import SwiftUI

// Checkbox with the consent text and a tappable link to the privacy notice
struct ConsentCheckboxRow: View {
  @Binding var isChecked: Bool
  let onNoticeTapped: () -> Void

  var body: some View {
    HStack(alignment: .top, spacing: 8) {
      Checkbox(isChecked: $isChecked)

      VStack(alignment: .leading, spacing: 6) {
        HStack(spacing: 4) {
          Text("He leído y acepto el")
            .foregroundColor(Color("OnBackground"))

          Button(action: onNoticeTapped) {
            Text("Aviso de privacidad")
              .foregroundColor(Color("PrimaryAdax"))
              .underline()
          }
          .buttonStyle(.plain)
        }
        .font(.system(size: 15, weight: .semibold))
        .lineLimit(1)
        .minimumScaleFactor(0.8)

        Text(
          "Al seleccionar esta casilla acepto el tratamiento de mis datos personales conforme al aviso."
        )
        .font(.system(size: 12))
        .foregroundColor(Color("InsideTextAndIcons"))
      }
      .padding(.top, 12)
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    SurfaceCard {
      ConsentCheckboxRow(isChecked: .constant(false), onNoticeTapped: {})
        .padding(16)
    }
    .padding()
  }
}
