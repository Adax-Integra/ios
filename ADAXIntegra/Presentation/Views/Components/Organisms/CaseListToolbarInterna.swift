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
    
    // show filterar when no filter is applied
    private var filterTitle: String {
        selectedFilter == "Todas" ? "Filtrar" : selectedFilter
    }
    
    
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack(spacing: 12) {
        SearchBarInterna(placeholder: "Buscar caso...", text: $searchText)

          Menu {
              Picker("Filtrar por urgencia", selection: $selectedFilter) {
                  ForEach(filterOptions, id: \.self) { option in
                      Text(option).tag(option)
                  }
              }
          } label: {
              HStack(spacing: 8) {
                  Icon(color: Color("PrimaryAdax"), systemName: "line.horizontal.decrease")
                  
                  Text(filterTitle)
                      .font(.headline)
                      .foregroundColor(Color("PrimaryAdax"))
                      .lineLimit(1)
                      .minimumScaleFactor(0.7)
              }
          }
          
          // keeping our own atomic design insted of the menu default one
          .buttonStyle(.plain)
          .frame(maxWidth: 80)
              .padding()
              .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color("PrimaryAdax"), lineWidth: 2)
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
    @Previewable @State var filter = "Todas"

    CaseListToolbar(
      searchText: .constant(""),
      selectedFilter: $filter,
      totalCases: 12,
      filterOptions: ["Todas", "Alta", "Media", "Baja", "Sin evaluar"]
    )
  .padding()
}
