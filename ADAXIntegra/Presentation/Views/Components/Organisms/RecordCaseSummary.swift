//
//  RecordCaseSummary.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 01/10/26.
//
// Record and Profile sumamry for general info about a paritcular case for US v-11

import SwiftUI

struct ProfileSummaryCard: View {
    var userName: String
    var recordId: String
    var lastModified: String
    var accompanimentType: String
    var onEditTapped: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            // we call the atoms that we have made that are relevant for this card
            HStack(alignment: .top, spacing: 12) {
                ProfileAvatar(size: 48)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(userName)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("Expediente: \(recordId)")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                .padding(.top, 4)
                
                Spacer()
                CircularEditButton(action: onEditTapped)
                    .offset(x: 8, y: -8)
            }
            
            Divider()
            
            // Details about last update and type of help
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Última Modificación")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    Text("Tipo de acompañamiento")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(lastModified)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.primary)
                    Text(accompanimentType)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    ZStack {
        Color(UIColor.systemGray6).ignoresSafeArea()
        
        ProfileSummaryCard(
            userName: " ",
            recordId: " ",
            lastModified: " ",
            accompanimentType: " ",
            onEditTapped: {
                print("Edit tapped")
            }
        )
        .padding()
    }
}
