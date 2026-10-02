//
//  CaseDetailsTemplate.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 02/10/26.
//



import SwiftUI

struct CaseDetailsTemplate<Content: View, BottomActions: View>: View {
    var caseNumber: String
    var status: String
    var onBack: () -> Void
    
    @ViewBuilder var content: Content
    @ViewBuilder var bottomActions: BottomActions

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                BackButton(action: onBack)
                
                Text("Caso \(caseNumber)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                StatusBadge(text: status)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 24)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    content
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }

            VStack {
                bottomActions
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(Color(UIColor.systemGray6).ignoresSafeArea())
        .navigationBarHidden(true)
    }
}
