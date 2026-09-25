//
//  CaseListToolbar.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 23/09/26.
//

import SwiftUI

struct CaseListToolbar: View {
  @Binding var searchText: String

  let totalCases: Int
  let onFilterTapped: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack(spacing: 12) {
        SearchBarInterna(placeholder: "Buscar caso...", text: $searchText)

        IconTextSecondaryButton(
          customWidth: 80,
          systemName: "line.3.horizontal.decrease",
          title: "Filtrar",
          isDisabled: false,
          action: onFilterTapped
        )
      }

      HStack {
        Text("Ordenado por Urgencia")
          .font(.system(size: 13, weight: .semibold))
          .tracking(1)
          .foregroundColor(Color("InsideTextAndIcons"))

        Spacer()

        CounterBadge(count: totalCases, label: "Casos totales")

      }
    }
  }
}

#Preview {
  CaseListToolbar(
    searchText: .constant(""),
    totalCases: 12,
    onFilterTapped: {
      print("filtrar tapped")  // Just to comfirm the button is being clicked
    }
  )
  .padding()
}
