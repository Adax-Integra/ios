//
//  CaseInfoCard.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 01/10/26.
//
// General info  of a particular case for US v-11 Get Case Details

import SwiftUI

struct CaseInfoCard: View {
   // var violenceType: String
  //  var location: String
    var hasLawyer: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Detalles de caso")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: 12) {
// we call up the molecules previously made
                
         //       DetailRow(iconName: "tag", text: violenceType)
        //        DetailRow(iconName: "mappin.and.ellipse", iconColor: .orange, text: location)
                LawyerStatusRow(hasLawyer: hasLawyer)
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
        
        CaseInfoCard(
         //   violenceType: "Acoso cibernético",
        //    location: "Querétaro",
            hasLawyer: true
        )
        .padding()
    }
}
