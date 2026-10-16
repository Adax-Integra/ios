//
//  DateFieldRow.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 15/10/26.
//

import SwiftUI

struct DateFieldRow: View {
  let label: String
  @Binding var date: Date

  var body: some View {
    HStack(spacing: 12) {
      Image(systemName: "calendar")
        .font(.system(size: 22))
        .foregroundColor(Color("OnBackgroundColor"))
      Text(label)
        .font(.system(size: 15))
        .foregroundColor(Color("IconColor"))
      Spacer()
      // El estilo compacto ya dibuja la "píldora" gris con la fecha, como en tu diseño
      DatePicker("", selection: $date, displayedComponents: .date)
        .labelsHidden()
        .tint(Color("PrimaryColor"))
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 10)
    .background(Color("CardColor"))
    .clipShape(RoundedRectangle(cornerRadius: 12))
  }
}
