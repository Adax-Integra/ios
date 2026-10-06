//
//  CircleIcon.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 06/10/26.
//



import SwiftUI

struct CircleIcon: View {
    let systemName: String
    var size: CGFloat = 52
    
    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: size * 0.4))
            .foregroundColor(Color("OnBackground"))
            .frame(width: size, height: size)
            .background(
                Circle().fill(Color("PrimaryAdax").opacity(0.15))
            )
    }
}

#Preview {
    HStack(spacing: 16) {
        CircleIcon(systemName: "folder.badge.plus")
        CircleIcon(systemName: "pencil")
        CircleIcon(systemName: "bubble.left")
    }
    .padding()
}
