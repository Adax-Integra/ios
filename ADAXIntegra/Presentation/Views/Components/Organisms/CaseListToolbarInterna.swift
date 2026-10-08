//
//  CaseListToolbar.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 23/09/26.
//

import SwiftUI

struct CaseListToolbar: View {
  @Binding var searchText: String
    @Binding var selectedFilter: String

  let totalCases: Int
    let filterOptions: [String]
    
    
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
        SearchBarInterna(placeholder: "Buscar caso...", text: $searchText)
        
      HStack(spacing: 12) {
        
          Menu {
              Picker("Filtrar por urgencia", selection: $selectedFilter) {
                  ForEach(filterOptions, id: \.self) { option in
                      Text(option).tag(option)
                  }
              }
          } label: {
              
              FilterChip(title: "Urgencia", isActive: selectedFilter != "Todas")
              }
          .buttonStyle(.plain)
          
          Spacer()
          
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
    @Previewable @State var filter = "Todas"

    CaseListToolbar(
      searchText: .constant(""),
      selectedFilter: $filter,
      totalCases: 12,
      filterOptions: ["Todas", "Alta", "Media", "Baja", "Sin evaluar"]
    )
  .padding()
}
