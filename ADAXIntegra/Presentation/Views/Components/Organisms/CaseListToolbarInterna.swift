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

  // filter selected shows the urgency or "Urgencia" when there is no filtered aplied
  private var filterTitle: String {
    selectedFilter == "Todas" ? "Urgencia" : selectedFilter
  }

  // the clear button apears when there is a filter to clear
  private var hasActiveFilters: Bool {
    selectedFilter != "Todas" || !searchText.isEmpty
  }

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

          FilterChip(title: filterTitle)
        }

        .buttonStyle(.plain)

        Spacer()

        // resets the search and urgency filter
        if hasActiveFilters {
          Button {
            searchText = ""
            selectedFilter = "Todas"
          } label: {
            Text("Limpiar filtros")
              .font(.system(size: 13, weight: .semibold))
              .foregroundColor(Color("PrimaryAdax"))
          }
          .buttonStyle(.plain)
        }
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
