//
//  CasesScreenTemplate.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 22/09/26.
//

import SwiftUI

struct CasesScreenTemplate<Header: View, Content: View>: View {
    let header: Header
    let content: Content
    init(@ViewBuilder header: () -> Header, @ViewBuilder content: () -> Content) {
        self.header = header(); self.content = content()
    }
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                header
                content
            }
            .padding(16)
        }
        .background(Color("BackgroundColor"))
    }
}
