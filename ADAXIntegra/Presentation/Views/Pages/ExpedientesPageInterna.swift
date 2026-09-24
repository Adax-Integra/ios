//
//  ExpedientesPage.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 23/09/26.
//

import SwiftUI

struct ExpedientesPage: View {
    @State private var searchText = ""
    
    var body: some View {
        ListPageTemplate {
            PageHeader(title: "Expedientes", backAction: {})
        } toolbar: {
            CaseListToolbar(searchText: $searchText, totalCases: 12, onFilterTapped: { }
            )
        } content: {
            CaseCardInterna(name: "Maria Lopez",
                     urgency: "Alta",
                     state: "En proceso",
                     updateAt: Date(),
                     categories: ["Violencia Familiar", "Violencia Económica"]
            )
            
            CaseCardInterna(name: "Ana Torres",
                     urgency: "Baja",
                     state: "Sin empezar",
                     updateAt: nil,
                     categories: ["Violencia Psicológica"]
            )
            
            CaseCardInterna(name: "Sofia Guzman",
                     urgency: "Alta",
                     state: "Sin empezar",
                     updateAt: Date(),
                     categories: ["Violencia Fisica"]
            )
            CaseCardInterna(name: "Maite Alcantara",
                     urgency: "Media",
                     state: "En proceso",
                     updateAt: Date(),
                     categories: ["Violencia Fisica" , "Violencia Familiar"]
            )
        }
    }
}

#Preview {
    ExpedientesPage()
}

