//
//  TimelineTimeLabel.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 06/10/26.
//

import SwiftUI

struct TimelineTimeLabel: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(Color("PrimaryAdax"))
            .frame(width: 44, alignment: .leading)
                  
    }
}


#Preview {
    VStack (alignment: .leading, spacing: 12) {
        TimelineTimeLabel(text: "12:33")
        TimelineTimeLabel(text: "4:01")
    }
}
