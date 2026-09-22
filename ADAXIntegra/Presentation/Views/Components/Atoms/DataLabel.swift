//
//  DataLabel.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 22/09/26.
//

import SwiftUI

struct DateLabel: View {
    let prefix: String
    let value: String
    var body: some View {
        Text("\(prefix): \(value)")
            .font(.system(size: 13, weight: .medium))
            .foregroundColor(Color("IconColor"))
    }
}
