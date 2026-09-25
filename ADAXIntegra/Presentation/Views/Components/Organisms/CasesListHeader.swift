//
//  CasesListHeader.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 22/09/26.
//

import SwiftUI

struct CasesListHeader: View {
    @Binding var searchText: String
    let count: Int
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Casos").font(.system(size: 22, weight: .bold))
            SearchBar(text: $searchText)
            HStack {
                Text("ORDENADO POR FECHA").font(.system(size: 11, weight: .medium)).foregroundColor(Color("IconColor"))
                Spacer()
                CountBadge(count: count)
            }
        }
    }
}
