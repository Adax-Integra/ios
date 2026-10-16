//
//  CodeSentCard.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 06/10/26.
//



import SwiftUI

struct CodeSentCard: View {
    let email: String
    
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "envelope")
                .font(.system(size: 26))
                .foregroundColor(Color("PrimaryAdax"))
                .frame(width: 44)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("CÓDIGO ENVIADO A ")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color("IconColor"))
                
                
                Text(email)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color("OnBackgroundColor"))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            
            Spacer(minLength: 0)
        }
        
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius:20).fill(Color("CardColor"))
        )
    }
}

#Preview {
    CodeSentCard(email: "nicobravomiguel@gmail.com")
        .padding()
        .background(Color("Background"))
}
