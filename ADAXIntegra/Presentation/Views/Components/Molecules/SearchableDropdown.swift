//
//  SearchableDropdown.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 25/09/26.
//

import SwiftUI

struct SearchableDropdown: View {
    let title: String
    let prompt: String
    let options: [String]
    @Binding var selection: String?
    
    @State private var isPresented = false
    @State private var query = ""
    
    private var filtered: [String] {
        let q = query.trimmingCharacters(in: .whitespaces)
        guard !q.isEmpty else { return options }
        return options.filter {
            $0.range(of: q, options: [.caseInsensitive, .diacriticInsensitive]) != nil
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            FieldLabel(title)
            
            Button {
                isPresented = true
            } label: {
                SurfaceCard(borderColor: nil, borderWidth: 0) {
                    HStack {
                        Text(selection ?? prompt)
                            .foregroundStyle(selection == nil ? Color("InsideTextAndIcons") : Color("OnBackground"))
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundStyle(Color("InsideTextAndIcons"))
                    }
                    .padding(.horizontal, 14)
                    .frame(height: 50)
                }
            }
            .buttonStyle(.plain)
        }
        .sheet(isPresented: $isPresented) {
            NavigationStack {
                List(filtered, id:\.self) { option in
                    Button {
                        selection = option
                        isPresented = false
                        query = ""
                    } label: {
                        HStack {
                            Text(option)
                                .foregroundStyle(Color("OnBackground"))
                            Spacer()
                            if option == selection {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color("PrimaryAdax"))
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .searchable(text: $query, prompt: "Buscar...")
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancelar") {
                            isPresented = false
                            query = ""
                        }
                    }
                }
            }
            .tint(Color("PrimaryAdax"))
            .presentationDetents([.large])
        }
    }
}
